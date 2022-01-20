% 根据参数训练神经网络
function y = bpann(input, output,show,epochs,goal,learnRate,trainFn,layer_n)
	net = newff( minmax(input) , [layer_n 10] , { 'logsig' 'purelin' } , trainFn ); 
	net.trainparam.show = show ;
	net.trainparam.epochs = epochs ;
	net.trainparam.goal = goal ;
	net.trainParam.lr = learnRate ;
%     net.trainParam.showWindow = false; 
%     net.trainParam.showCommandLine = false; 
	size(input);
	size(output);
	y = train( net, input , output ) ;
end