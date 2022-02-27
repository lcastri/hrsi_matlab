function w = max_nan_window(A)
%max_nan_window: return max window size containing only NaNs
% - param A: (struct) agents struct
% - return w: (int) window size

    for c = 1 : size(A, 2)
        S = regionprops(isnan(A(:,c)),'PIxelIdxList','Area');
        [~,idx] = max([S.Area]);
        longest(c) = length(A(S(idx).PixelIdxList,c));
    end
    w = max(longest);
end

