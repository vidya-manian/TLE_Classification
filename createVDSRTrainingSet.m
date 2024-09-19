% Copyright 2018 The MathWorks, Inc.

function createVDSRTrainingSet(imds,newSize,upsampledDir)

if ~isfolder(upsampledDir)
    mkdir(upsampledDir);
end

while hasdata(imds)
    % Use only the luminance component for training
    [I,info] = read(imds);
    [~,fileName,~] = fileparts(info.Filename);
    
    I = rgb2ycbcr(I);
    Y = I(:,:,1);
    I = im2double(Y);
    
    upsampledImage = imresize(I,newSize,'bicubic');
    
    save([upsampledDirName filesep fileName '.mat'],'upsampledImage');
    
end

end