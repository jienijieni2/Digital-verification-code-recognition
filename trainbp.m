function y = trainbp(a, b,show,epochs,goal,learnRate,trainFn,layer_n)
	% bp 网络训练
    msgbox('正在训练网络，请耐心等待！', '提示');
	net = bpann(a', b',show,epochs,goal,learnRate,trainFn,layer_n);
    
    save bp.mat net
    msgbox('BPNN训练完成！', '提示');

end