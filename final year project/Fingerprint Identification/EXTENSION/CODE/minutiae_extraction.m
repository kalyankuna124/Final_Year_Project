function outImg = minutiae_extraction(image)
    % Convert opened image to binary
    binary_image = im2bw(image);
    
    % Thinning
    thin_image = ~bwmorph(binary_image, 'thin', Inf);
%     figure,
%     imshow(thin_image);
%     title('thin Image');
    
    
    % Window size
    N = 3;
    n = (N - 1) / 2;
    
    % Padding
    s = size(thin_image);
    r = s(1) + 2 * n;
    c = s(2) + 2 * n;
    temp = zeros(r, c);
    temp((n + 1):(end - n), (n + 1):(end - n)) = thin_image(:,:);
    
    % Display image
    outImg = zeros(r, c, 3);
    outImg(:, :, 1) = temp .* 255;
    outImg(:, :, 2) = temp .* 255;
    outImg(:, :, 3) = temp .* 255;
    
    % Minutiae detection
    ridge = zeros(r, c);
    bifurcation = zeros(r, c);

    for x = (n + 1 + 10):(s(1) + n - 10)
        for y = (n + 1 + 10):(s(2) + n - 10)
            e = 1;
            mat = zeros(N, N);
            
            for k = x - n:x + n
                f = 1;
                for l = y - n:y + n
                    mat(e, f) = temp(k, l);
                    f = f + 1;
                end
                e = e + 1;
            end
            
            if (mat(2, 2) == 0)
                ridge(x, y) = sum(sum(~mat));
                bifurcation(x, y) = sum(sum(~mat));
            end
        end
    end

    % Ridge End Finding
    [ridge_x, ridge_y] = find(ridge == 2);
    len = length(ridge_x);

    for i = 1:len
        outImg((ridge_x(i) - 3):(ridge_x(i) + 3), (ridge_y(i) - 3), 2:3) = 0;
        outImg((ridge_x(i) - 3):(ridge_x(i) + 3), (ridge_y(i) + 3), 2:3) = 0;
        outImg((ridge_x(i) - 3), (ridge_y(i) - 3):(ridge_y(i) + 3), 2:3) = 0;
        outImg((ridge_x(i) + 3), (ridge_y(i) - 3):(ridge_y(i) + 3), 2:3) = 0;

        outImg((ridge_x(i) - 3):(ridge_x(i) + 3), (ridge_y(i) - 3), 1) = 255;
        outImg((ridge_x(i) - 3):(ridge_x(i) + 3), (ridge_y(i) + 3), 1) = 255;
        outImg((ridge_x(i) - 3), (ridge_y(i) - 3):(ridge_y(i) + 3), 1) = 255;
        outImg((ridge_x(i) + 3), (ridge_y(i) - 3):(ridge_y(i) + 3), 1) = 255;
    end

    % Bifurcation Finding
    [bifurcation_x, bifurcation_y] = find(bifurcation == 4);
    len = length(bifurcation_x);

    for i = 1:len
        outImg((bifurcation_x(i) - 3):(bifurcation_x(i) + 3), (bifurcation_y(i) - 3), 1:2) = 0;
        outImg((bifurcation_x(i) - 3):(bifurcation_x(i) + 3), (bifurcation_y(i) + 3), 1:2) = 0;
        outImg((bifurcation_x(i) - 3), (bifurcation_y(i) - 3):(bifurcation_y(i) + 3), 1:2) = 0;
        outImg((bifurcation_x(i) + 3), (bifurcation_y(i) - 3):(bifurcation_y(i) + 3), 1:2) = 0;

        outImg((bifurcation_x(i) - 3):(bifurcation_x(i) + 3), (bifurcation_y(i) - 3), 3) = 255;
        outImg((bifurcation_x(i) - 3):(bifurcation_x(i) + 3), (bifurcation_y(i) + 3), 3) = 255;
        outImg((bifurcation_x(i) - 3), (bifurcation_y(i) - 3):(bifurcation_y(i) + 3), 3) = 255;
        outImg((bifurcation_x(i) + 3), (bifurcation_y(i) - 3):(bifurcation_y(i) + 3), 3) = 255;
    end

end
