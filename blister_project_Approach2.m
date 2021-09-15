clear all;
close all;

message = sprintf('Use stored image or take a fresh picture?');
reply = questdlg(message, 'Please choose one', 'Use Downloaded', 'Snap now', 'Snap now');
if strcmpi(reply, 'Use Downloaded')
    I = imread('pills_used_2.jpeg');
else
% capturing image of blister from webcam
    cam = webcam;
    pause(2);
    I = snapshot(cam);
    clear cam;
end

I = imread("pills_used_2.jpeg");
gs = im2gray(I);
gsAdj = imadjust(gs);

BW = imbinarize(gsAdj, "adaptive");

H = fspecial("average");                % creating an averaging filter
BW1 = imfilter(BW, H);                  % filtering the B&W image with averaging filter
BW2 = ~imfilter(BW1, H, "replicate");   % negating and again filtering the image with the same filter while eliminating edge lines
BW3 = BW1 - BW2;                        % removing negated components from filtered image
imshow(BW3);


% d = drawline;
% pos = d.Position;
% diffPos = diff(pos);
% diameter = hypot(diffPos(1), diffPos(2))




[centresTablet, radiiTablet] = imfindcircles(BW3,[30 50],'ObjectPolarity', 'bright', 'sensitivity', 0.95);
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
disp ('Nearest Tablet is at:'), disp(min_coordinate);
        