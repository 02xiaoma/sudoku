function img_centered = remove_bound(img)
    img_centered = [];
    for ii=size(img, 1):-1:1
        if (~all(img(ii,:)))
            img_centered = [img(ii,:);img_centered];
        end
    end
    for ii=size(img_centered, 2):-1:1
        if (all(img_centered(:, ii)))
            img_centered(:, ii) = [];
        end
    end
end