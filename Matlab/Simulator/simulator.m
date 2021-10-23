%matlab script for decoding FPGA SIM VIDEO DATA 
tic
rgbhv_stream = readtable('frame_data original un effected.txt');

%%

pix_clk = table2array(rgbhv_stream(:,1)); %pix clk
H_sync = table2array(rgbhv_stream(:,2)); %
V_sync = table2array(rgbhv_stream(:,3)); %
Draw_A = table2array(rgbhv_stream(:,7)); %

%% seperate collors and and replace nans with 0s

r = table2array(rgbhv_stream(:,4));
g = table2array(rgbhv_stream(:,5));
b = table2array(rgbhv_stream(:,6));



%% find the meaningful transsions

pxclk_transistion = strfind(pix_clk',[0 1]);
Hsync_edge = strfind(H_sync',[0 1]); %find 0 to 1 transisions
Hwidth = Hsync_edge(4) - Hsync_edge(3);

Vsync_edge = strfind(V_sync',[0 1]); %find 0 to 1 transisions

%%

sim_img = zeros(640,480,3);

x =1;
y =1;

for i =1:size(r)
    
     
    sim_img(y,x,1)= r(i,1) * Draw_A(i);  
    sim_img(y,x,2)= g(i,1) * Draw_A(i); 
    sim_img(y,x,3)= b(i,1) * Draw_A(i); 
    x = x+1;
    if(any(Hsync_edge(:) == i))
    x = 1;
    y = y +1;
    

    
    
    
    end
    
end


% 
%%

imageout =uint8(sim_img);
imshow(imageout)

toc