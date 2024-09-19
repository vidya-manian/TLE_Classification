% Directorio donde están las imágenes originales
input_folder  = 'C:\Users\RA-4-01\Downloads\TLEs GS and CS\Elve';

% Directorio donde se guardarán las imágenes transformadas
output_folder = 'C:\Users\RA-4-01\Downloads\TLEs GS and CS';

transformation = 'shear';


% Lista de archivos en el directorio de entrada
imageFormats = {'*.jpg', '*.jpeg', '*.png', '*.PNG'};
    files = [];
    for i = 1:length(imageFormats)
        files = [files; dir(fullfile(input_folder, imageFormats{i}))];
    end

for k = 1:length(files)
    baseFileName = files(k).name;
    fullFileName = fullfile(input_folder, baseFileName);
    img = imread(fullFileName);

    switch transformation
        case 'flip'
            img_transformed = flip(img ,2); % Espejo horizontal
        case 'rotate'
            rotation_angle = randi([-15, 15], 1, 1); % Rango de rotación
            img_transformed = imrotate(img, rotation_angle, 'bilinear', 'crop');
        case 'shear'
            % Cizallamiento más complejo en MATLAB, necesita una matriz de transformación
            shear_factor_x = tand(randi([-15, 15], 1, 1)); % Cizallamiento horizontal
            shear_factor_y = tand(randi([-15, 15], 1, 1)); % Cizallamiento vertical
            tform = affine2d([1 shear_factor_x 0; shear_factor_y 1 0; 0 0 1]);
            img_transformed = imwarp(img, tform);
        case 'saturation'
            % La saturación se ajusta en el espacio de color HSV
            hsv = rgb2hsv(img);
            factor = 1 + (rand * 0.5 - 0.25); % Ajuste de saturación
            hsv(:, :, 2) = hsv(:, :, 2) * factor;
            img_transformed = hsv2rgb(hsv);
        case 'exposure'
            % Ajustar el valor de exposición en el espacio de color HSV
            hsv = rgb2hsv(img);
            factor = 1 + (rand * 0.7 - 0.35); % Ajuste de exposición
            hsv(:, :, 3) = hsv(:, :, 3) * factor;
            hsv(:, :, 3) = min(max(hsv(:, :, 3), 0), 1);
            img_transformed = hsv2rgb(hsv);
        otherwise
            disp(['Transformación "', transformation, '" no reconocida. Se guarda la imagen sin cambios.']);
            img_transformed = img;
    end

    % Guarda la imagen transformada
    outputFileName = fullfile(output_folder, [transformation, '_', baseFileName]);
    imwrite(img_transformed, outputFileName);
end

