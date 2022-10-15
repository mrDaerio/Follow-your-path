close, clear, clc
%% Best Match for voltage divider
W=3000;
B=14000;
DeltaV=@(Rs) 5*B./(B+Rs)-5*W./(W+Rs);
Rs=[0:100000];
plot(Rs,DeltaV(Rs));
RsBest = sqrt(B*W);
fprintf ("Best match Rs: %f\n",RsBest);
DeltaVmax = DeltaV(RsBest);
fprintf ("Max DeltaV: %f\n",DeltaVmax);
hold on
plot (RsBest,DeltaVmax,'r.','markersize',10);
text (RsBest,DeltaVmax,"  \DeltaVmax");

%% Best Match for bridge
VoBridge = @(R1,R4) 5*(W./(RsBest+W)-R4./(R1+R4));
constant = 3;
edge=10000;
dim=100;
R4=linspace(1,edge,dim);
R1=linspace(1,edge,dim);
matrix = zeros(dim);
for x=1:dim
    matrix(x,:) = VoBridge(R1(x),R4);
end
surf(R4,R4,matrix,'edgecolor','none')
[m,i]=min(abs(matrix(:)));
x=floor(i/edge);
y=mod(i,edge);
grid on
hold on
%surf(linspace(1,edge,100),linspace(1,edge,100),zeros(dim))
xlabel('R1')
ylabel('R4')
const=5
VoBridge(const,sqrt(W/B)*const)