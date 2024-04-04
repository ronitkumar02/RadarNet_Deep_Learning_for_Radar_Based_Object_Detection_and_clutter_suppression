imgs_train  = zeros(374,500,3,92,'single');
resps_train = zeros(374,500,3,92,'single');

for ind = 1:92
    % Read the image data using imread and store it in the corresponding slice
    imgs_train(:,:,:,ind) = im2single(imread("New radar dataset\validation\Input\Clutter ("+ind+").png"));
    resps_train(:,:,:,ind) = im2single(imread("New radar dataset\validation\Output\noClutter ("+ind+").png"));
end
imgs_val  = zeros(374,500,3,92,'single');
resps_val = zeros(374,500,3,92,'single');

for ind = 1:92
    % Read the image data using imread and store it in the corresponding slice
    imgs_val(:,:,:,ind) = im2single(imread("New radar dataset\validation\Input\Clutter ("+ind+").png"));
    resps_val(:,:,:,ind) = im2single(imread("New radar dataset\validation\Output\noClutter ("+ind+").png"));
end

layers = [
    imageInputLayer([374 500 3]);
    convolution2dLayer([4 4],64,'Padding','same');
    batchNormalizationLayer;
    leakyReluLayer(0.2);
    convolution2dLayer([4 4],128,'Padding','same');
    batchNormalizationLayer;
    leakyReluLayer(0.2);
    convolution2dLayer([4 4],256,'Padding','same');
    batchNormalizationLayer;
    leakyReluLayer(0.2);
    convolution2dLayer([4 4],512,'Padding','same');
    batchNormalizationLayer;
    leakyReluLayer(0.2);
    convolution2dLayer([4 4],3,'Padding','same');
    batchNormalizationLayer;
    leakyReluLayer(0.2);
    reluLayer; % Add a ReLU layer to ensure non-negative outputs
    regressionLayer];

trainSet = 1:92;
valSet = 1:10;

opts = trainingOptions("adam", ...
    MaxEpochs=50, ...
    MiniBatchSize=32, ...
    Shuffle="every-epoch", ...
    InitialLearnRate=0.1, ...
    ValidationData={imgs_val(:,:,:,valSet),resps_val(:,:,:,valSet)}, ...
    ValidationFrequency=25, ...
    OutputNetwork='best-validation-loss', ...
    Verbose=true);

[net,info] = trainNetwork(imgs_train(:,:,:,trainSet),resps_train(:,:,:,trainSet),layers,opts);


save('net.mat', 'net')
save('info.mat', 'info')

