% 图片分割器

function [y,imgGray,I,J2,I2,Idx] = cutting(img, isshow , way , level)
	
    imgGray = rgb2gray(img); % 转为灰度图像
    
    if way == 1
        I=ksw_ga_improve1(imgGray);
    end
    if way == 2
        thresh = graythresh(imgGray); % 自动确定二值化阀值
        I = 1 - im2bw(imgGray,thresh); % 转换为二值图像并反转
    end
    if way == 3
        I = 1 - im2bw(imgGray,level); % 转换为二值图像并反转
    end
        
    J2 = medfilt2(I); %3*3中值滤波
	I2 = bwareaopen(J2, 15, 8);	 % 去除连通分量中小于15的离散点
    
    
    varray = sum(I2); 
    
    [L,num] = bwlabel(I2,8); %找到图中的连通域，num为连通域数量
    class = [1:num] ;
    imgsize = size(L);
    Idx = zeros(num,4);
    flag = zeros(1,num);
    for i = 1 : imgsize(1, 1)
        for j = 1 : num
            if size(find(L(i,:) == class(j)))==[1 0]
                flag_temp = false;
            else
                flag_temp = true;
            end
            if flag(1,j) == 0 && flag_temp
                Idx(j,1) = i-1;
                flag(1,j) = 1;
            end
            if flag(1,j) == 1 && ~flag_temp
                Idx(j,2) = i;
                flag(1,j) = 2;
            end
            if i == imgsize(1, 1) && flag(1,j) == 1
                Idx(j,2) = i;
                flag(1,j) = 2;
            end
        end
    end
    flag = zeros(1,num);
    for i = 1 : imgsize(1, 2)
        for j = 1 : num
            if size(find(L(:,i) == class(j)))==[0 1]
                flag_temp = false;
            else
                flag_temp = true;
            end
            if flag(1,j) == 0 && flag_temp
                Idx(j,3) = i-1;
                flag(1,j) = 1;
            end
            if flag(1,j) == 1 && ~flag_temp
                Idx(j,4) = i;
                flag(1,j) = 2;
            end
            if i == imgsize(1, 2) && flag(1,j) == 1
                Idx(j,4) = i;
                flag(1,j) = 2;
            end
        end
    end
    for i = 1:num
        for k=1:4
            if Idx(i,k) == 0
                Idx(i,k) = 1;
            end
        end
        t = I2(Idx(i,1):Idx(i,2), Idx(i,3):Idx(i,4));
 	    y{i} = t;
    end


	if isshow
        figure
        subplot(1,5,1)
        imshow(img); 
        title("原图像");
        subplot(1,5,2)
		imshow(imgGray); 
        title("灰度化");
        subplot(1,5,3)
		imshow(I); % 
        title("二值化");
        subplot(1,5,4)
		imshow(J2); % 
        title("中值滤波");
        subplot(1,5,5)
		imshow(I2); % 
        title("去除离散噪声");
% 		harray = sum(I2');
% 		x1 = 1 : imgsize(1, 1);
% 		x2 = 1 : imgsize(1, 2);
% 		figure; % 打开一个新的窗口显示分割图
% 		plot(x1, harray, 'r+-', x2, varray, 'y*-');

		figure; % 打开一个新的窗口显示灰度图像
		imshow(I2); % 显示转化后的灰度图像
        
        
        for i=1:num
            hold on
            plot([Idx(i,3),Idx(i,3)],[Idx(i,1),Idx(i,2)],'r--','LineWidth', 2);
            hold on
            plot([Idx(i,4),Idx(i,4)],[Idx(i,1),Idx(i,2)],'r--','LineWidth', 2);
            hold on
            plot([Idx(i,3),Idx(i,4)],[Idx(i,1),Idx(i,1)],'r--','LineWidth', 2);
            hold on
            plot([Idx(i,3),Idx(i,4)],[Idx(i,2),Idx(i,2)],'r--','LineWidth', 2);
        end
    end
    
    
end
