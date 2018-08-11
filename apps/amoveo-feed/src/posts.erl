-module(posts).
-behaviour(gen_server).
-export([start_link/0,code_change/3,handle_call/3,handle_cast/2,handle_info/2,init/1,terminate/2,
	new/1, lookup/2, censor/1]).
-record(post, {text = "", id = 0}).
-record(d, {posts = [], id_counter = 0}).
-define(LOC, "posts.db").
init(ok) -> 
    process_flag(trap_exit, true),
    utils:init(#d{}, ?LOC).
start_link() -> gen_server:start_link({local, ?MODULE}, ?MODULE, ok, []).
code_change(_OldVsn, State, _Extra) -> {ok, State}.
terminate(_, X) -> 
    utils:save(X, ?LOC),
    io:format("died!"), ok.
handle_info(_, X) -> {noreply, X}.
handle_cast({censor, ID}, X) -> 
    P = X#d.posts,
    P2 = censor_helper(ID, P),
    X2 = X#d{posts = P2},
    {noreply, X2};
handle_cast(_, X) -> {noreply, X}.
handle_call({new, Text}, _From, X) -> 
    ID = X#d.id_counter,
    New = #post{id = ID, text = Text},
    NewPosts = add_post(New, X#d.posts),
    X2 = X#d{posts = NewPosts,
	     id_counter = ID + 1},
    {reply, ID, X2};
handle_call({lookup, Start, Many}, _From, X) -> 
    PostsText = lookup_helper(Start, Many, X#d.posts),
    {reply, PostsText, X};
handle_call(_, _From, X) -> {reply, X, X}.

new(Text) ->%returns the ID of the new post.
    gen_server:call(?MODULE, {new, Text}).
lookup(Start, Many) ->
    gen_server:call(?MODULE, {lookup, Start, Many}).
censor(ID) ->
    gen_server:cast(?MODULE, {censor, ID}).

censor_helper(_, []) -> [];
censor_helper(ID, [H|T]) when (H#post.id == ID) ->
    H2 = H#post{text = "censored"},
    [H2|T];
censor_helper(ID, [H|T]) ->
    [H|censor_helper(ID, T)].

lookup_helper(_, _, []) -> [];
lookup_helper(_, 0, _) -> [];
lookup_helper(Start, Many, [H|T]) when H#post.id < Start ->
    lookup_helper(Start, Many, T);
lookup_helper(Start, Many, [H|T]) ->
    [H#post.text|lookup_helper(Start, Many-1, T)].

add_post(New, L) ->
    H = config:history_to_remember(),
    SL = length(L),
    L2 = if
	     SL > H -> lists:droplast(L);
	     true -> L
	 end,
    [New|L2].

	    
