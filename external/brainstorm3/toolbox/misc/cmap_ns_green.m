function CMap = cmap_ns_green(nbVals)

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
    0.0306    0.0556    0.9444
    0.0298    0.0798    0.9202
    0.0290    0.1040    0.8960
    0.0283    0.1283    0.8717
    0.0275    0.1525    0.8475
    0.0267    0.1767    0.8233
    0.0259    0.2009    0.7991
    0.0251    0.2251    0.7749
    0.0243    0.2493    0.7507
    0.0236    0.2736    0.7264
    0.0228    0.2978    0.7022
    0.0220    0.3220    0.6780
    0.0212    0.3462    0.6538
    0.0204    0.3704    0.6296
    0.0196    0.3946    0.6054
    0.0188    0.4188    0.5812
    0.0181    0.4431    0.5569
    0.0173    0.4673    0.5327
    0.0165    0.4915    0.5085
    0.0157    0.5157    0.4843
    0.0149    0.5399    0.4601
    0.0141    0.5641    0.4359
    0.0133    0.5883    0.4117
    0.0126    0.6126    0.3874
    0.0118    0.6368    0.3632
    0.0110    0.6610    0.3390
    0.0102    0.6852    0.3148
    0.0094    0.7094    0.2906
    0.0086    0.7336    0.2664
    0.0078    0.7578    0.2421
    0.0071    0.7821    0.2179
    0.0063    0.8063    0.1937
    0.0055    0.8305    0.1695
    0.0047    0.8547    0.1453
    0.0039    0.8789    0.1211
    0.0031    0.9031    0.0969
    0.0024    0.9274    0.0726
    0.0016    0.9516    0.0484
    0.0008    0.9758    0.0242
         0    1.0000         0
    0.0250    0.9750         0
    0.0500    0.9500         0
    0.0750    0.9250         0
    0.1000    0.9000         0
    0.1250    0.8750         0
    0.1500    0.8500         0
    0.1750    0.8250         0
    0.2000    0.8000         0
    0.2250    0.7750         0
    0.2500    0.7500         0
    0.2750    0.7250         0
    0.3000    0.7000         0
    0.3250    0.6750         0
    0.3500    0.6500         0
    0.3750    0.6250         0
    0.4000    0.6000         0
    0.4250    0.5750         0
    0.4500    0.5500         0
    0.4750    0.5250         0
    0.5000    0.5000         0
    0.5250    0.4750         0
    0.5500    0.4500         0
    0.5750    0.4250         0
    0.6000    0.4000         0
    0.6250    0.3750         0
    0.6500    0.3500         0
    0.6750    0.3250         0
    0.7000    0.3000         0
    0.7250    0.2750         0
    0.7500    0.2500         0
    0.7750    0.2250         0
    0.8000    0.2000         0
    0.8250    0.1750         0
    0.8500    0.1500         0
    0.8750    0.1250         0
    0.9000    0.1000         0
    0.9250    0.0750         0
    0.9500    0.0500         0
    0.9750    0.0250         0
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
     
     
     
     