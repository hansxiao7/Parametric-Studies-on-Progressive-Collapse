clc
clear
%This code is to generate predicted disp vs F curve%
predictions = load('case 4-5 predictions.txt');
Fy = load('case 4-5 Fy.txt');

i=2;
    output = [];
    output(1,1) = 0;
    output(1,2) = 0;
    output(2,1) = predictions(i, 2);
    output(2,2) = predictions(i, 1);
%     %quadratic function
%     F = [predictions(i,1), predictions(i,3), Fy(i)]';
%     disp = [predictions(i,2)^2, predictions(i,2), 1
%             predictions(i,4)^2, predictions(i,4), 1
%             predictions(i,5)^2, predictions(i,5), 1];
%     paras = inv(disp)*F;
%     step = floor((predictions(i,5)-predictions(i,2))/0.01);
%     for j = 1:step 
%         output(2+j,1) = j*0.01+predictions(i,2);
%         output(2+j,2) = [output(2+j,1)^2, output(2+j,1), 1] * paras;
%     end
%     output(3+step, 1) = predictions(i,5);
%     output(3+step, 2) = Fy(i);
%     %save("prediction"+i+".txt",'output');
% 
%     
%     

%exponential function a-b*0.75^x
    F = [predictions(i,1),predictions(i,3)]';
    disp = [1, -0.75^predictions(i,2)
            1, -0.75^predictions(i,4)];
    paras = inv(disp)*F;
    step = floor((predictions(i,4)-predictions(i,2))/0.01);
    for j = 1:step 
        output(2+j,1) = j*0.01+predictions(i,2);
        output(2+j,2) = [1, -0.75^output(2+j,1)]* paras;
    end
    output(3+step, 1) = predictions(i,5);
    output(3+step, 2) = Fy(i);