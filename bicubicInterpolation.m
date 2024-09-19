% Ruta a la carpeta que contiene las imágenes
folderPath = 'C:\Users\RA-4-01\Documents\TLEs\TLE Full Classification\TLE 7 Classes Lucema - copia';

% Tamaño al que deseas redimensionar las imágenes
targetSize = [224, 224, 3];

% Lista de extensiones de archivo permitidas
allowedExtensions = {'.jpg', '.png', '.bmp', '.jpeg'}; % Ajusta según tus necesidades

% Obtener una lista de todas las carpetas en el directorio
subFolders = dir(folderPath);

% Iterar a través de las carpetas
for classIndex = 3:length(subFolders)
    subFolderPath = fullfile(folderPath, subFolders(classIndex).name);
    
    % Obtener una lista de archivos de imagen en la carpeta
    imageFiles = dir(subFolderPath);
    
    % Iterar a través de los archivos de imagen en la carpeta
    for imageIndex = 1:length(imageFiles)
        % Obtener el nombre y extensión del archivo
        [~,~,ext] = fileparts(imageFiles(imageIndex).name);
        
        % Verificar si la extensión es una de las permitidas
        if ismember(ext, allowedExtensions)
            imagePath = fullfile(subFolderPath, imageFiles(imageIndex).name);
            
            % Leer la imagen
            img = imread(imagePath);
            
            % Redimensionar la imagen al tamaño deseado usando interpolación bicúbica
            img_resized = imresize(img, targetSize(1:2), 'bicubic');
            
            % Guardar la imagen redimensionada en el mismo lugar
            imwrite(img_resized, imagePath);
        end
    end
end
