function RunPreTrainedModel(imgs)
    m = matfile('net.mat');
    net = m.net;
    imgs_input = im2single(imread(imgs));
   
    resp_act = predict(net,imgs_input);
    resp_act(resp_act<0) = 0;
    resp_act = resp_act/max(resp_act(:));
    %filename = sprintf('image_%d.png', ind); % You can change the file format if needed
    %imwrite(resp_act, filename);
    
    fh = figure;
    
    subplot(1,2,1)
    image = imgs_input;
    % Find pixels where all RGB values are 0\
    black_pixels = all(image == 0, 3);
    
    % Create a mask for replacing black pixels
    mask = cat(3, black_pixels, black_pixels, black_pixels);
    
    % Replace black pixels with 1 1 1
    image(mask) = 1;
    imshow(image);
    clim([-120 20])
    colorbar
    axis on
    axis equal
    axis tight
    title('Input')
    
    subplot(1,2,2)
    image = resp_act;
    % Find pixels where all RGB values are 0\
    black_pixels = all(image == 0, 3);
    
    % Create a mask for replacing black pixels
    mask = cat(3, black_pixels, black_pixels, black_pixels);
    
    % Replace black pixels with 1 1 1
    image(mask) = 1;

    clim([-120 20])
    colorbar
    imshow(image);
    clim([-120 20])
    colorbar
    axis on
    axis equal
    axis tight
    title('Output')
    
    fh.Position = fh.Position + [0 0 560 0];
end

