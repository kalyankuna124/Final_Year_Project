function feature2DImage = applyPCA(gabormag)
    numRows = size(gabormag, 1);
    numCols = size(gabormag, 2);

    X = 1:numCols;
    Y = 1:numRows;
    [X,Y] = meshgrid(X,Y);
    featureSet = cat(3, gabormag, X);
    featureSet = cat(3, featureSet, Y);

    numPoints = numRows * numCols;
    X = reshape(featureSet, numPoints, []);

    X = bsxfun(@minus, X, mean(X));
    X = bsxfun(@rdivide, X, std(X));

    coeff = pca(X);
    feature2DImage = reshape(X * coeff(:,1), numRows, numCols);
end
