function CMap = cmap_ns_grey(nbVals)

% @=============================================================================
% This function is part of the Brainstorm software:
% https://neuroimage.usc.edu/brainstorm
% 
% Copyright (c)2000-2019 University of Southern California & McGill University
% This software is distributed under the terms of the GNU General Public License
% as published by the Free Software Foundation. Further details on the GPLv3
% license can be found at http://www.gnu.org/copyleft/gpl.html.
% 
% FOR RESEARCH PURPOSES ONLY. THE SOFTWARE IS PROVIDED "AS IS," AND THE
% UNIVERSITY OF SOUTHERN CALIFORNIA AND ITS COLLABORATORS DO NOT MAKE ANY
% WARRANTY, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO WARRANTIES OF
% MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, NOR DO THEY ASSUME ANY
% LIABILITY OR RESPONSIBILITY FOR THE USE OF THIS SOFTWARE.
%
% For more information type "brainstorm license" at command prompt.
% =============================================================================@
%
% Authors: Sylvain Baillet, 2012

CMap =[
         0    1.0000    1.0000
    0.0004    0.9889    0.9996
    0.0007    0.9777    0.9993
    0.0011    0.9666    0.9989
    0.0014    0.9555    0.9986
    0.0018    0.9443    0.9982
    0.0022    0.9332    0.9978
    0.0025    0.9221    0.9975
    0.0029    0.9109    0.9971
    0.0032    0.8998    0.9968
    0.0036    0.8887    0.9964
    0.0040    0.8775    0.9960
    0.0043    0.8664    0.9957
    0.0047    0.8553    0.9953
    0.0050    0.8441    0.9950
    0.0054    0.8330    0.9946
    0.0058    0.8219    0.9942
    0.0061    0.8107    0.9939
    0.0065    0.7996    0.9935
    0.0069    0.7885    0.9931
    0.0072    0.7773    0.9928
    0.0076    0.7662    0.9924
    0.0079    0.7551    0.9921
    0.0083    0.7439    0.9917
    0.0087    0.7328    0.9913
    0.0090    0.7217    0.9910
    0.0094    0.7105    0.9906
    0.0097    0.6994    0.9903
    0.0101    0.6883    0.9899
    0.0105    0.6771    0.9895
    0.0108    0.6660    0.9892
    0.0112    0.6549    0.9888
    0.0115    0.6437    0.9885
    0.0119    0.6326    0.9881
    0.0123    0.6215    0.9877
    0.0126    0.6103    0.9874
    0.0130    0.5992    0.9870
    0.0133    0.5881    0.9867
    0.0137    0.5769    0.9863
    0.0141    0.5658    0.9859
    0.0144    0.5547    0.9856
    0.0148    0.5435    0.9852
    0.0151    0.5324    0.9849
    0.0155    0.5213    0.9845
    0.0159    0.5101    0.9841
    0.0162    0.4990    0.9838
    0.0166    0.4879    0.9834
    0.0169    0.4767    0.9831
    0.0173    0.4656    0.9827
    0.0177    0.4545    0.9823
    0.0180    0.4433    0.9820
    0.0184    0.4322    0.9816
    0.0188    0.4211    0.9812
    0.0191    0.4099    0.9809
    0.0195    0.3988    0.9805
    0.0198    0.3876    0.9802
    0.0202    0.3765    0.9798
    0.0206    0.3654    0.9794
    0.0209    0.3542    0.9791
    0.0213    0.3431    0.9787
    0.0216    0.3320    0.9784
    0.0220    0.3208    0.9780
    0.0224    0.3097    0.9776
    0.0227    0.2986    0.9773
    0.0231    0.2874    0.9769
    0.0234    0.2763    0.9766
    0.0238    0.2652    0.9762
    0.0242    0.2540    0.9758
    0.0245    0.2429    0.9755
    0.0249    0.2318    0.9751
    0.0252    0.2206    0.9748
    0.0256    0.2095    0.9744
    0.0260    0.1984    0.9740
    0.0263    0.1872    0.9737
    0.0267    0.1761    0.9733
    0.0270    0.1650    0.9730
    0.0274    0.1538    0.9726
    0.0278    0.1427    0.9722
    0.0281    0.1316    0.9719
    0.0285    0.1204    0.9715
    0.0288    0.1093    0.9712
    0.0292    0.0982    0.9708
    0.0296    0.0870    0.9704
    0.0299    0.0759    0.9701
    0.0303    0.0648    0.9697
    0.0307    0.0536    0.9693
    0.0310    0.0425    0.9690
    0.0314    0.0314    0.9686
    0.0456    0.0456    0.9594
    0.0598    0.0598    0.9502
    0.0740    0.0740    0.9410
    0.0883    0.0883    0.9317
    0.1025    0.1025    0.9225
    0.1167    0.1167    0.9133
    0.1309    0.1309    0.9041
    0.1451    0.1451    0.8949
    0.1593    0.1593    0.8857
    0.1736    0.1736    0.8765
    0.1878    0.1878    0.8672
    0.2020    0.2020    0.8580
    0.2162    0.2162    0.8488
    0.2304    0.2304    0.8396
    0.2446    0.2446    0.8304
    0.2588    0.2588    0.8212
    0.2731    0.2731    0.8119
    0.2873    0.2873    0.8027
    0.3015    0.3015    0.7935
    0.3157    0.3157    0.7843
    0.3299    0.3299    0.7751
    0.3441    0.3441    0.7659
    0.3583    0.3583    0.7567
    0.3726    0.3726    0.7474
    0.3868    0.3868    0.7382
    0.4010    0.4010    0.7290
    0.4152    0.4152    0.7198
    0.4294    0.4294    0.7106
    0.4436    0.4436    0.7014
    0.4579    0.4579    0.6921
    0.4721    0.4721    0.6829
    0.4863    0.4863    0.6737
    0.5005    0.5005    0.6645
    0.5147    0.5147    0.6553
    0.5289    0.5289    0.6461
    0.5431    0.5431    0.6369
    0.5574    0.5574    0.6276
    0.5716    0.5716    0.6184
    0.5858    0.5858    0.6092
    0.6000    0.6000    0.6000
    0.6100    0.5850    0.5850
    0.6200    0.5700    0.5700
    0.6300    0.5550    0.5550
    0.6400    0.5400    0.5400
    0.6500    0.5250    0.5250
    0.6600    0.5100    0.5100
    0.6700    0.4950    0.4950
    0.6800    0.4800    0.4800
    0.6900    0.4650    0.4650
    0.7000    0.4500    0.4500
    0.7100    0.4350    0.4350
    0.7200    0.4200    0.4200
    0.7300    0.4050    0.4050
    0.7400    0.3900    0.3900
    0.7500    0.3750    0.3750
    0.7600    0.3600    0.3600
    0.7700    0.3450    0.3450
    0.7800    0.3300    0.3300
    0.7900    0.3150    0.3150
    0.8000    0.3000    0.3000
    0.8100    0.2850    0.2850
    0.8200    0.2700    0.2700
    0.8300    0.2550    0.2550
    0.8400    0.2400    0.2400
    0.8500    0.2250    0.2250
    0.8600    0.2100    0.2100
    0.8700    0.1950    0.1950
    0.8800    0.1800    0.1800
    0.8900    0.1650    0.1650
    0.9000    0.1500    0.1500
    0.9100    0.1350    0.1350
    0.9200    0.1200    0.1200
    0.9300    0.1050    0.1050
    0.9400    0.0900    0.0900
    0.9500    0.0750    0.0750
    0.9600    0.0600    0.0600
    0.9700    0.0450    0.0450
    0.9800    0.0300    0.0300
    0.9900    0.0150    0.0150
    1.0000         0         0
    1.0000    0.0114         0
    1.0000    0.0227         0
    1.0000    0.0341         0
    1.0000    0.0455         0
    1.0000    0.0568         0
    1.0000    0.0682         0
    1.0000    0.0795         0
    1.0000    0.0909         0
    1.0000    0.1023         0
    1.0000    0.1136         0
    1.0000    0.1250         0
    1.0000    0.1364         0
    1.0000    0.1477         0
    1.0000    0.1591         0
    1.0000    0.1705         0
    1.0000    0.1818         0
    1.0000    0.1932         0
    1.0000    0.2045         0
    1.0000    0.2159         0
    1.0000    0.2273         0
    1.0000    0.2386         0
    1.0000    0.2500         0
    1.0000    0.2614         0
    1.0000    0.2727         0
    1.0000    0.2841         0
    1.0000    0.2955         0
    1.0000    0.3068         0
    1.0000    0.3182         0
    1.0000    0.3295         0
    1.0000    0.3409         0
    1.0000    0.3523         0
    1.0000    0.3636         0
    1.0000    0.3750         0
    1.0000    0.3864         0
    1.0000    0.3977         0
    1.0000    0.4091         0
    1.0000    0.4205         0
    1.0000    0.4318         0
    1.0000    0.4432         0
    1.0000    0.4545         0
    1.0000    0.4659         0
    1.0000    0.4773         0
    1.0000    0.4886         0
    1.0000    0.5000         0
    1.0000    0.5114         0
    1.0000    0.5227         0
    1.0000    0.5341         0
    1.0000    0.5455         0
    1.0000    0.5568         0
    1.0000    0.5682         0
    1.0000    0.5795         0
    1.0000    0.5909         0
    1.0000    0.6023         0
    1.0000    0.6136         0
    1.0000    0.6250         0
    1.0000    0.6364         0
    1.0000    0.6477         0
    1.0000    0.6591         0
    1.0000    0.6705         0
    1.0000    0.6818         0
    1.0000    0.6932         0
    1.0000    0.7045         0
    1.0000    0.7159         0
    1.0000    0.7273         0
    1.0000    0.7386         0
    1.0000    0.7500         0
    1.0000    0.7614         0
    1.0000    0.7727         0
    1.0000    0.7841         0
    1.0000    0.7955         0
    1.0000    0.8068         0
    1.0000    0.8182         0
    1.0000    0.8295         0
    1.0000    0.8409         0
    1.0000    0.8523         0
    1.0000    0.8636         0
    1.0000    0.8750         0
    1.0000    0.8864         0
    1.0000    0.8977         0
    1.0000    0.9091         0
    1.0000    0.9205         0
    1.0000    0.9318         0
    1.0000    0.9432         0
    1.0000    0.9545         0
    1.0000    0.9659         0
    1.0000    0.9773         0
    1.0000    0.9886         0
    1.0000    1.0000         0];
     
     
     
     