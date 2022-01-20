function c1=cross_ga_improve(s_code1,k,population)
   
   %交叉算子
   
   if k <= 20                                 %交叉概率取0.8,0.6
       pc=0.8; 
   else
       pc=0.6; 
   end
   
   ww=s_code1;
   
   for i=1:(pc*population/2-1)
       r=abs(round(rand(1)*20)-3);
       for j=(r+1):8
           temp=ww(2*i-1,j);
           ww(2*i-1,j)=ww(2*i,j);
           ww(2*i,j)=temp;
       end
   end
   
   c1=ww;
end
   
           
           
       
       
   
   
   
   