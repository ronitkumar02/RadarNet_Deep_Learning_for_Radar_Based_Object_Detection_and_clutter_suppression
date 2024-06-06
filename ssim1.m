% Read the two images
for i = 1:5
    % Construct the filenames for the images
    img1_filename = sprintf('image_%d.png', i);
    img2_filename = sprintf('image_2%d.png', i);

    % Read the images
    img1 = imread(img1_filename);
    img2 = imread(img2_filename);

    % Calculate SSIM
    ssim_value = ssim(img1, img2);

    % Display SSIM value
    disp(['SSIM value between image ' num2str(i) ' and image2' num2str(i) ': ' num2str(ssim_value)]);
end
