% 创建数据集
% buildataset: 用来创建神经网络适合的训练集
function [inputs outputs] = builddataset(pathname,handles)
    % 创建数据集
    % pathname='D:\课程\计算智能\BP数字验证码\img\';
    file = dir(pathname); %除去“.”“..”两个文件夹
    file_num = size(file,1)-2;
    temp = cat(1,strvcat(file(10).name,file.name));
    class = temp(4:13,:);
    inputs = [];
    outputs = [];
    for i = 1:file_num
        pathName = [pathname,class(i,:),'\'];
        temp_png = dir([pathName,'\*.png']);
        temp_imgName = cat(1,strvcat(temp_png(10).name,temp_png.name));
        pic_num = size(temp_png,1);
        imgName = temp_imgName(2:pic_num+1,:);  %得到文件夹内pic_num张图片的名称
        for j = 1:pic_num
            I2 = 1 - im2bw(imread([pathName,imgName(j,:)]),0.9); % 转换为二值图像并反转
            L= bwlabel(I2,8); %找到图中的连通域，num为连通域数量
            imgsize = size(L);
            Idx = zeros(1,4);
            flag = 0;
            for k = 1 : imgsize(1, 1)
                if size(find(L(k,:) == 1))==[1 0]
                    flag_temp = false;
                else
                    flag_temp = true;
                end
                if flag == 0 && flag_temp
                    Idx(1,1) = k-1;
                    flag = 1;
                end
                if flag == 1 && ~flag_temp
                    Idx(1,2) = k;
                    flag = 2;
                end
                if k == imgsize(1, 1) && flag == 1
                    Idx(1,2) = k;
                    flag = 2;
                end
            end
            flag = 0;
            for k = 1 : imgsize(1, 2)
                if size(find(L(:,k) == 1))==[0 1]
                    flag_temp = false;
                else
                    flag_temp = true;
                end
                if flag == 0 && flag_temp
                    Idx(1,3) = k-1;
                    flag = 1;
                end
                if flag == 1 && ~flag_temp
                    Idx(1,4) = k;
                    flag = 2;
                end
                if k == imgsize(1, 2) && flag == 1
                    Idx(1,4) = k;
                    flag = 2;
                end
            end
            for k=1:4
                if Idx(1,k) == 0
                    Idx(1,k) = 1;
                end
            end
            t = I2(Idx(1,1):Idx(1,2), Idx(1,3):Idx(1,4));
            I2 = imresize(t,[32,32]); %缩放至32*32
            I2 = im2bw(I2,0.5);
            axes(handles.axes1);
            if j == 200
                j;
            end
            imshow(I2);
            [m n]=size(I2);            
            A=reshape(I2',[1 m*n]);   %将I2矩阵变为1行m*n列的矩阵i
            inputs=[inputs;A];
            B=zeros(1,file_num);
            B(1,i) = 1;
            outputs = [outputs;B];
        end
    end 
    save inputs.mat inputs;
    save outputs.mat outputs;
    msgbox('数据集创建成功！', '提示');
end


