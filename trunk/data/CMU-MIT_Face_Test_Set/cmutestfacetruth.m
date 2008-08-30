% cmutestfacetruth - a simple script to create a face ground truth text
%   from eye, nose, lip potions' ground truth text of CMU Face Test Set
%
% Synopsis
%   cmutestfacetruth(dirname, show, fprint)
%
% Input arguments
%   (string) dirname   directory name ('test' or 'test-low' or 'newtest')
%   (bool)   [show = false]
%                      show figure or not
%   (bool)   [fprint = true]
%                      print facial ground truth to
%                      dirname/facegroundtruth.txt
% Output format
%   filename left-x upper-y width height
%
% Examples
%   facegroundtruth('test', true, true);
%
% Requirements
%   cvuCsvread.m, cvuImgread.m

% Authors
%   Naotoshi Seo <sonots(at)sonots.com>
% History
%   2008/08/28
function cmutestfacetruth(dirname, show, fprint)
if ~exist('show', 'var') || isempty(show)
    show = 0; 
end
if ~exist('fprint', 'var') || isempty(fprint)
    fprint = 1; 
end

M = cvuCsvread([dirname, '/groundtruth.txt'], ' ');
fid = fopen([dirname, '/facegroundtruth.txt'], 'w');
previmgfile = '';
for i = 2:length(M)
    imgfile = M{i}{1};
    if show
        if ~strcmp(previmgfile, imgfile)
            figure; imshow(cvuImgread([dirname, '/', imgfile])); hold on;
        end
        for j = 2:2:12
            plot(M{i}{j:j+1},'y*');
        end
    end

    [left_eye_x left_eye_y] = M{i}{2:3};
    [right_eye_x right_eye_y] = M{i}{4:5};
    [nose_x nose_y] = M{i}{6:7};
    [left_corner_mouse_x left_corner_mouse_y] = M{i}{8:9};
    [center_mouse_x center_mouse_y] = M{i}{10:11};
    [right_corner_mouse_x right_corner_mouse_y] = M{i}{12:13};
    
    diff_y = center_mouse_y - nose_y;
    bottom = center_mouse_y + diff_y;
    top = left_eye_y - diff_y;
    height = abs(top - bottom);
    
    diff_x1 = right_corner_mouse_x - center_mouse_x;
    right = right_eye_x + diff_x1;
    diff_x2 = center_mouse_x - left_corner_mouse_x;
    left = left_eye_x - diff_x2;
    width = abs(right - left);
   
    if show
        plot([left right],[top top], 'y-');
        plot([left left],[top bottom], 'y-');
        plot([right right],[top bottom], 'y-');
        plot([left right],[bottom bottom], 'y-');
    end
    previmgfile = imgfile;

    fprintf(fid, '%s %d %d %d %d\n', imgfile, fix(left), fix(top), fix(width), fix(height));
end
fclose(fid);
