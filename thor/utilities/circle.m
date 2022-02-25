function circle(x, y, r, txt, c)
    hold on
    th = 0:pi/50:2*pi;
    x_circle = r * cos(th) + x;
    y_circle = r * sin(th) + y;
    circles = fill(x_circle, y_circle, c,'LineStyle','none');
    text(x, y, txt)
    hold off
    set(circles,'facealpha',.5)
    axis equal
end


