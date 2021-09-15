clear all;
close all;

message = sprintf('Use stored image or take a fresh picture?');
reply = questdlg(message, 'Please choose one', 'Use Downloaded', 'Snap now', 'Snap now');
if strcmpi(reply, 'Use Downloaded')
    I = imread('pills_red3.jpeg');
else
% capturing image of blister from webcam
    cam = webcam;
    pause(2);
    I = snapshot(cam);
    clear cam;
end

I = imread('pills.jpeg');
%pre-processing of image to enhance desired features
gs = im2gray(I);
gsAdj = imadjust(gs);
figure(1)
imshow(I)
BW = imbinarize(gsAdj, "adaptive");     % binarize by thresholding
H = fspecial("average");                % averaging filter
BW1 = imfilter(BW, H);                  % applying averaging filter
BW2 = ~imfilter(BW1, H, "replicate");   % negating the B&W image
BW3 = BW1 - BW2;                        % removing negated components from filtered image

%detecting diameter of pills
%{
d = drawline;
pos = d.Position;
diffPos = diff(pos);
diameter = hypot(diffPos(1), diffPos(2))
%}

%detecting pills present in blister
figure(2)
imshow(BW3);
[centresTablet, radiiTablet] = imfindcircles(BW3,[15 25],'ObjectPolarity', 'dark', 'sensitivity', 0.95);
viscircles(centresTablet, radiiTablet,'LineStyle','--', 'edgecolor', 'r');
n = length(centresTablet);
disp('The number of tablets left in the blister is:')
disp(n)
min = 1000;
min_coordinate = [0 0];
for i = 1:n
    d = sqrt(centresTablet(i, 1)^2 + centresTablet(i, 2)^2);        %calculating distance of each pill from top left of the screen
    if (d<min)
        min = d;                                                    %finding nearest pill
        min_coordinate = [centresTablet(i,1) centresTablet(i,2)];   %storing coordinates of nearest pill, i.e, the next target pill
    end
end
disp ('Nearest Tablet is at: '), disp(min_coordinate);
