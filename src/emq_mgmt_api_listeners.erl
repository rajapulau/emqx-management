%%--------------------------------------------------------------------
%% Copyright (c) 2015-2017 EMQ Enterprise, Inc. (http://emqtt.io).
%%
%% Licensed under the Apache License, Version 2.0 (the "License");
%% you may not use this file except in compliance with the License.
%% You may obtain a copy of the License at
%%
%%     http://www.apache.org/licenses/LICENSE-2.0
%%
%% Unless required by applicable law or agreed to in writing, software
%% distributed under the License is distributed on an "AS IS" BASIS,
%% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%% See the License for the specific language governing permissions and
%% limitations under the License.
%%--------------------------------------------------------------------

-module(emq_mgmt_api_listeners).

-author("Feng Lee <feng@emqtt.io>").

-rest_api(#{name   => list_listeners,
            method => 'GET',
            path   => "/listeners/",
            func   => list,
            descr  => "A list of listeners in the cluster"}).

-rest_api(#{name   => list_node_listeners,
            method => 'GET',
            path   => "/nodes/:node/listeners",
            func   => list,
            descr  => "A list of listeners on the node"}).

%% List listeners on a node.
list(#{node := Node}, _Params) ->
    {ok, format(emq_mgmt:listeners(list_to_atom(Node)))};

%% List listeners in the cluster.
list(_Binding, _Params) ->
    {ok, [{Node, format(Listener)} || {Node, Listener} <- emq_mgmt:listeners()]}.

format(Listeners) ->
    [ Info#{listen_on = list_to_binary(esockd:to_string(ListenOn))}
     || Info = #{listen_on := ListenOn} <- Listeners];

format({error, Reason}) -> [{error, Reason}].

