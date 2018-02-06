function [mzscore maxmz outlier outlier_num] = mzscore(x, x_date, thresh, dist)
%
% ZSCORE uses the Modified Z-sccore method to label outliers assuming the
% data are normally distributed. This method replaces the average by the
% median and the standard deviation by the median of absolute deviations
% (MAD). These estimators are more robust to outliers.
%
% Data in 'x' are organized so that columns are the time series and rows
% are the time intervals. All series contain the same number of
% observations.
%
% 'x_date' is a column vector (cell array) containing the dates of the
% corresponding data in 'x'.
%
% The variable 'thresh' is the maximum threshold and its default value
% is 3.5.
%
% The variable 'dist' indicates if the series are assumed to be normal
% (default) or log-normally distributed. It can take the values 0 (normal)
% or 1 (log-normal).
%
% [mzscore maxmz outlier outlier_num] = mzscore(...) returns the following information:
% mzscore       - matrix of the same size as 'x' containing the Modified Z-scores
% maxmz         - maximum absolute value of Modified Z-scores for the size of
%                 the time series. It helps to identify potential problems in case
%                 'thresh' is greater than the maximum score ('maxmz').
% outlier       - cell array specifying the date and the series number (column
%                 number in 'x') where the potential outliers are situated.
% outlier_num   - matrix providing row and column numbers of the values in
%                 'x' considered as potential outliers.
%
% Created by Francisco Augusto Alcaraz Garcia
%            alcaraz_garcia@yahoo.com
%
% References:
%
% 1) B. Iglewicz; D.C. Hoaglin (1993). How to Detect and Handle Outliers.
% ASQC Basic References in Quality Control, vol. 16, Wisconsin, US.


% % Check number of input arguements
% if (nargin < 2) || (nargin > 4)
%     error('Requires two to four input arguments.')
% end
% 
% % Define default values
% if nargin == 2,
%     thresh = 3.5;
%     dist = 0;
% elseif nargin == 3, 
%     dist = 0;
% end
% 
% % Normal transformation
% if dist == 1,
%     x = log(x);
% end
% 
% % Check for validity of inputs
% if ~isnumeric(x) || ~isreal(x) || ~iscellstr(x_date),
%     error('Input x must be a numeric array, x must be positive for log-normality, and x_date must be a string table.')
% end
thresh = 3.5;
dist = 0;
[n, c] = size(x);
mad = median(abs((x-repmat(median(x),n,1))));
mzscore = 0.6745*(x-repmat(median(x),n,1))./repmat(mad,n,1);
[i,j] = find(abs(mzscore) > thresh)


% maxmz = (n-1)/sqrt(n);
% 
% if ~isempty(i),
%     outlier = [x_date(i) cellstr(strcat('Series', num2str(j)))];
%     outlier_num = [i j];
% else
%     outlier = ('No outliers have been identified!');
%     outlier_num = ('No outliers have been identified!');
% end