function w = max_nan_window(A)
    for c = 1 : size(A, 2)
        S = regionprops(isnan(A(:,c)),'PIxelIdxList','Area');
        [~,idx] = max([S.Area]);
        longest(c) = length(A(S(idx).PixelIdxList,c));
    end
    w = max(longest);
end

