function [out, psnr] = dn_wiener2 (noisy_image, clean_image, sigman )

% denoising using laplacian prior

[wc] = fwt_image(noisy_image,6); % 6-level DWT: lowest band is 16x16
[CA1, CH1, CV1, CD1] = get_subbands(wc);
[CA2, CH2, CV2, CD2] = get_subbands(CA1);
[CA3, CH3, CV3, CD3] = get_subbands(CA2);
[CA4, CH4, CV4, CD4] = get_subbands(CA3);
[CA5, CH5, CV5, CD5] = get_subbands(CA4);

% Reconstruction algorithm
% ca5 .... ch3_w cv3_w cd3_w ch2_w
% cv2_w cd2_w ch1_w cv1_w cd1_w
% -------------------------------

ch5_w = wiener2(CH5,[5 5], sigman^2);
cv5_w = wiener2(CV5,[5 5], sigman^2);
cd5_w = wiener2(CD5,[5 5], sigman^2);

ch4_w = wiener2(CH4,[5 5], sigman^2);
cv4_w = wiener2(CV4,[5 5], sigman^2);
cd4_w = wiener2(CD4,[5 5], sigman^2);

ch3_w = wiener2(CH3,[5 5], sigman^2);
cv3_w = wiener2(CV3,[5 5], sigman^2);
cd3_w = wiener2(CD3,[5 5], sigman^2);

ch2_w = wiener2(CH2,[5 5], sigman^2);
cv2_w = wiener2(CV2,[5 5], sigman^2);
cd2_w = wiener2(CD2,[5 5], sigman^2);

ch1_w = wiener2(CH1,[5 5], sigman^2);
cv1_w = wiener2(CV1,[5 5], sigman^2);
cd1_w = wiener2(CD1,[5 5], sigman^2);

% reconstructed image
% ---------------------------

ca5 = CA5;

wc = [ca5 ch5_w
    cv5_w cd5_w ];
wc = [wc ch4_w
    cv4_w cd4_w ];
wc = [wc ch3_w
    cv3_w cd3_w ];
wc = [wc ch2_w
    cv2_w cd2_w ];
wc = [wc ch1_w
    cv1_w cd1_w ];

out = iwt_image(wc,6);
psnr = feval('psnr',clean_image,out);