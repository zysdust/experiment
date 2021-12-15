%25 10
figure
X = [1:16];
Y = [3.858e-03,4.176e-03,2.976e-03,3.197e-03,7.359e-03,5.370e-03,1.515e-03,2.343e-03,1.023e-02,...
    5.388e-03,3.696e-03,1.409e-03,8.303e-03,2.450e-03,4.364e-03,3.679e-03];
plot(X,Y,"--",'LineWidth',1)
hold on
stem(X,Y,'LineWidth',0.7)
hold on
X = [1.1:16.1];
Y = [3.649e-03,3.861e-03,2.800e-03,3.059e-03,6.931e-03,5.161e-03,1.440e-03,2.231e-03,9.217e-03,...
4.917e-03,3.542e-03,1.353e-03,7.746e-03,2.363e-03,4.143e-03,3.590e-03];
stem(X,Y,'LineWidth',0.7)
hold on
X = [1.2:16.2];
Y = [2.946e-03,2.405e-03,1.606e-03,1.204e-03,4.933e-03,2.723e-03,1.021e-03,1.209e-03,6.684e-03,...
3.384e-03,2.087e-03,8.853e-04,5.143e-03,1.519e-03,2.003e-03,1.516e-03];
stem(X,Y,'LineWidth',0.7)
hold on
X = [1.3:16.3];
Y = [3.847e-03,3.960e-03,2.408e-03,2.249e-03,7.635e-03,4.496e-03,1.451e-03,1.908e-03,1.006e-02,...
5.110e-03,3.121e-03,1.222e-03,8.834e-03,2.406e-03,3.369e-03,2.884e-03];
stem(X,Y,'LineWidth',0.7)
hold on
X = [1.4:16.4];
Y = [1.452e-03,1.797e-03,1.208e-03,1.125e-03,3.177e-03,1.653e-03,6.922e-04,8.995e-04,3.583e-03,...
2.106e-03,1.504e-03,5.315e-04,2.428e-03,8.894e-04,1.379e-03,1.218e-03];
stem(X,Y,'LineWidth',0.7)
hold on
X = [1.5:16.5];
Y = [2.287e-03,2.348e-03,1.480e-03,1.494e-03,4.269e-03,2.637e-03,8.688e-04,1.238e-03,6.267e-03,...
3.348e-03,2.025e-03,6.864e-04,4.013e-03,1.237e-03,2.174e-03,1.735e-03];
stem(X,Y,'LineWidth',0.7)
hold on
X = [1.6:16.6];
Y = [3.736e-03,4.002e-03,2.617e-03,2.719e-03,7.390e-03,4.797e-03,1.526e-03,...
2.154e-03,1.002e-02,5.108e-03,3.459e-03,1.311e-03,8.668e-03,2.484e-03,3.741e-03,3.231e-03];
stem(X,Y,'LineWidth',0.7)
hold on
X = [1.7:16.7];
Y = [3.762e-03,3.908e-03,2.598e-03,2.695e-03,7.278e-03,5.009e-03,1.470e-03,2.132e-03,9.518e-03,...
5.240e-03,3.424e-03,1.323e-03,8.110e-03,2.438e-03,3.858e-03,3.438e-03];
stem(X,Y,'LineWidth',0.7)
hold on
X = [1.8:16.8];
Y = [3.609e-03,4.031e-03,2.591e-03,2.875e-03,6.947e-03,4.690e-03,1.431e-03,2.095e-03,9.561e-03,...
5.209e-03,3.307e-03,1.137e-03,7.657e-03,2.198e-03,3.859e-03,3.209e-03];
stem(X,Y,'LineWidth',0.7)



%title('HV results of all algorithms for 5 objectives','FontName', 'Times New Roman','FontSize', 10)
set(gca,'looseInset',[0 0 0 0])   % 去除图片白色边框
xlabel('Grouping of algorithms','FontName', 'Times New Roman','FontSize', 18)
ylabel('Average of HV','FontName', 'Times New Roman','FontSize', 18) 
legend('MaOEA-DS','MaOEA-DS','MaOEA-DES','RVEA','NSGA-III','MOEA/DD','1by1EA','MOMBI-II','KnEA','tDEA','Location','best','FontSize', 12)
set(gca,'XTick',1:16);






