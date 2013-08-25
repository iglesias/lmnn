function graphical_insight_plot(x)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

plot(x(1,1:4),x(2,1:4),'oy','MarkerSize',10,'MarkerFaceColor','y')
hold on
plot(x(1,5:6),x(2,5:6),'sb','MarkerSize',10,'MarkerFaceColor','b')
plot(x(1,7:8),x(2,7:8),'sr','MarkerSize',10,'MarkerFaceColor','r')
hold off
xlabel('x')
ylabel('y')
axis([-1.5 1.5 -1.5 1.5]);

end

