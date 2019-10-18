-module(rivera).
-compile(export_all).

init_chat() ->
	register(pong, spawn(rivera, pong, [])). %initiates chat, tapos magsspawn ng pong


pong() -> %kapag dating dito, maghihintay si pong ng Pong_ID galing sa isang user
	receive
		{Pong_ID} ->
			Name = string:strip(io:get_line("Enter Your Name: "), right, $\n), %kapag natanggap na ni pong yung ID ng isang user, magpproceed na siya para kunin
			%yung name
			register(ping, spawn(rivera, ping, [Name, Pong_ID])), %magsspawn ng isang function para makapagsend
			register(recv, spawn(rivera, recv, [])),                 %magsspawn ng function para makapagreceive ng message
			ping ! start          %start ping/pagsend
	end.


init_chat2(User1_ID) -> %after maginitiate si init_chat(), sasaluhin niya yung ID ng na-spawn na init_chat
	{pong, User1_ID} ! {self()}, %sinesend niya kay pong yung User1_ID para di na maghintay si init_chat at makapagproceed na yung both sa pagkuha ng name
	Name = string:strip(io:get_line("Enter Your Name: "), right, $\n), %get name
	register(recv, spawn(rivera, recv, [])), %function to receive
	register(ping, spawn(rivera, ping, [Name, User1_ID])), %function to send
	ping ! start. %start sending


ping(Name, User_ID) -> %sending the message
	receive
		start ->
			self() ! start;

		quit ->
			exit(self(), kill),
			io:format(ok)

	end,
	Name2 = Name ++ ": ",
	timer:sleep(10),
	Message = string:strip(io:get_line(Name2), right, $\n), %to remove the \n
	%sending the message
	Bye = string:equal(Message, "bye"),
	if
		Bye == true -> %pag equal sa "bye", sends quit msg
			recv ! quit,
			[Head | _] = nodes(), %get the user connected using nodes(), ilagay yung
			{recv, Head} ! {ping, Name, Message}, %value sa head, then send message.
			io:format("ok ~n");
		true ->
			[Head | _] = nodes(),
			{recv, Head} ! {ping, Name, Message},
			ping(Name, User_ID) %pwede pang magsend ng message kaya nandito yung ping na function
	end.

recv() -> %function for receiving the message
	receive %waits for input,
		{ping, Name, Message} -> %kapag nareceive ng yung message from ping, may checker kung Bye ba or not yung Message
			Bye = string:equal(Message, "bye"),
			if
				Bye == true ->
					io:format("~s: ~s~n", [Name, Message]),
					exit(whereis(ping), kill),
					ping ! quit,
					io:format("Your partner has disconnected. ~n"),
					self() ! quit;

				true ->
					io:format("~s: ~s~n", [Name, Message]),
					recv() %after printing the message, maghihintay na naman ng panibagong message, so call recv() again

			end;

		quit -> %kapag quit naman yung natanggap galing kay ping, exit na
			exit(normal)
	end.
