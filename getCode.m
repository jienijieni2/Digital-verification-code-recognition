%生成验证码
function Y = getCode(codeInputs,codeOutputs,pathname,code_num)
    
%     pathname = 'D:\课程\计算智能\BP数字验证码\code_img\';
    randColor=@()randi([0,200],[1,3]);           % 生成随机颜色的匿名函数
    
    for m = 1:code_num
        code_img = ones(60,200,3)*255;
        code_name = '';
        start_i = 0;
        start_j = 20;
        border = zeros(1,4);
        bandian_Num = randi([3,6]);
        for i=1:4
            idx = randi(size(codeInputs,1));
            [maxN,class] = max(codeOutputs(idx,:));
            code_name = [code_name char(48+class-1)];

            start_i = randi([14,18]);
            if i==1
                border(1,3) = start_i;
            end
            if start_i < border(1,3)
                border(1,3) = start_i;
            end
            if start_i > border(1,4)
                border(1,4) = start_i;
            end
            if i == 1
                start_j = start_j + randi([5,10]);
                border(1,1) = start_j-8;
            else
                start_j = start_j + randi([5,10]) + 32;
            end
            color = randColor();
            for j=1:3
                img_temp = codeInputs(idx,:) * color(j);
                for k=1:1024
                    if img_temp(k) == 0
                        img_temp(k) = 255;
                    end
                end   
                img = reshape(img_temp,[32,32])';
                code_img(start_i:start_i+31,start_j:start_j+31,j) = img;
            end
            border(1,2) = start_j+31+4;
        end
        border(1,3) = border(1,3) - 8;
        border(1,4) = border(1,4) + 31 + 4;
        code_img = uint8(code_img);
        bandian_pos = [];
        %添加离散斑点噪声
        for m=1:bandian_Num
            size_m = 2;

            isOK = false;
            while(~isOK)
                temp1 = randi(4);
                if temp1 == 1
                    m_i = randi(57);
                    m_j = randi(border(1,1));
                else if temp1 == 2
                        m_i = randi(57);
                        m_j = randi([border(1,2),197]);
                    else if temp1 == 3
                            m_i = randi(border(1,3));
                            m_j = randi(197);
                        else
                            m_i = randi([border(1,4),57]);
                            m_j = randi(197);
                        end
                    end
                end
                isOK = true;  %假设生成的位置合理
                for n=1:size(bandian_pos,1)
                    if abs(m_i - bandian_pos(n,1))<5 || abs(m_j - bandian_pos(n,2))<5
                        isOK = false;
                        break;
                    end
                end
                if isOK
                     bandian_pos = [bandian_pos;m_i,m_j];
                end
            end

            color_m = randColor();
            for n=1:3
                code_img(m_i:m_i+size_m,m_j:m_j+size_m,n) = color_m(n);
            end
        end

    %     添加椒盐噪声
        code_img=imnoise(code_img,'salt & pepper',0.02);

    %     figure;
    %     imshow(code_img)
        imwrite(code_img,[pathname,code_name,'.jpg'])
    end
    msgbox('验证码生成成功！', '提示');
end
