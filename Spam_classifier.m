words_in_train = "";
D = 3000;
% Making Dictionary of most frequent words in the entire training dataset.
file_ptr = dir('/MATLAB Drive/train/*/*.txt');
for k = 1:length(file_ptr)  
    Mails = file_ptr(k).name;
    dr = file_ptr(k).folder;
    file = fileread(strcat(dr, '/', Mails));
    file = regexprep(file, '\<\w{1,2}\>', "");
    file = regexprep(file, '\d*', "");
    file = regexprep(file, '[^a-zA-Z_0-9 $]', "");
    words_in_train = strcat(words_in_train, ' ', file);
end

words = strsplit(words_in_train, ' ' )';
[words_u, ~, xU] = unique(words);
counts = accumarray( xU, 1 );

[~, xS] = sort( counts, 'descend' );

dictionary = [words_u(xS), counts(xS)];
dictionary = dictionary(1:D, :);

allwords_in_spam = "";
spam_prob = zeros(D,1);
file_ptr = dir('/MATLAB Drive/train/Spam/*.txt');
for k = 1:length(file_ptr)
    Mails = file_ptr(k).name;
    dr = file_ptr(k).folder;
    file = fileread(strcat(dr, '/', Mails));
    file = regexprep(file, '\<\w{1,2}\>', "");
    file = regexprep(file, '\d*', "");
    file = regexprep(file, '[^a-zA-Z_0-9 $]', "");
    allwords_in_spam = strcat(allwords_in_spam, ' ', file);
end
S = k;

words_in_spam = strsplit(allwords_in_spam, ' ' )';
[words_in_spam_u, ~, xU] = unique(words_in_spam);
counts_spam = accumarray( xU, 1 );

[~, xS] = sort( counts_spam, 'descend' );

words_in_spam_us = words_in_spam_u(xS);
counts_spam_s = counts_spam(xS);

total_spam_dict_words = 0;
spam_dict = zeros(D,1);
for i = 1:D    
    for j = 1:length(words_in_spam_us)
        if strcmp(words_in_spam_us(j), dictionary(i,1))
            spam_dict(i) = counts_spam_s(i);
            break;
        end
    end
    total_spam_dict_words = total_spam_dict_words + spam_dict(i);
end

for i = 1:D        
    spam_prob(i) = (spam_dict(i) + 1)/(total_spam_dict_words + D);
end

allwords_in_non_spam = "";
non_spam_prob = zeros(D,1);
file_ptr = dir('/MATLAB Drive/train/Non_Spam/*.txt');
for k = 1:length(file_ptr)
    Mails = file_ptr(k).name;
    dr = file_ptr(k).folder;
    file = fileread(strcat(dr, '/', Mails));
    file = regexprep(file, '\<\w{1,2}\>', "");
    file = regexprep(file, '\d*', "");
    file = regexprep(file, '[^a-zA-Z_0-9 $]', "");
    allwords_in_non_spam = strcat(allwords_in_non_spam, ' ', file);
end
NS = k;

words_in_non_spam = strsplit(allwords_in_non_spam, ' ' )';
[words_in_non_spam_u, ~, xU] = unique(words_in_non_spam);
counts_non_spam = accumarray( xU, 1 );

[~, xS] = sort( counts_non_spam, 'descend' );

words_in_non_spam_us = words_in_non_spam_u(xS);
counts_non_spam_s = counts_non_spam(xS);

total_non_spam_dict_words = 0;
non_spam_dict = zeros(D,1);
for i = 1:D    
    for j = 1:length(words_in_non_spam_us)
        if strcmp(words_in_non_spam(j), dictionary(i,1))
            non_spam_dict(i) = counts_non_spam_s(i);
            break;
        end
    end
    total_non_spam_dict_words = total_non_spam_dict_words + non_spam_dict(i);    
end

for i = 1:D        
    non_spam_prob(i) = (non_spam_dict(i) + 1)/(total_non_spam_dict_words + D);
end

file_ptr = dir('/MATLAB Drive/test/Spam/*.txt');
spam_count = 0;
non_spam_count = 0;

for k = 1:length(file_ptr)
    Mails = file_ptr(k).name;
    dr = file_ptr(k).folder;
    file = fileread(strcat(dr, '/', Mails));
    file = regexprep(file, '\<\w{1,2}\>', "");
    words_in_mail = strsplit(file, ' ' )';
    c = 0;
    d = 0;
    for x = 1:D
        for y = 1:length(words_in_mail)
            if strcmp(words_in_mail(y), dictionary(x,1))                
                c = c + log(1-spam_prob(x)) - log(spam_prob(x));
                d = d + log(1-non_spam_prob(x)) - log(non_spam_prob(x));
                break;
            end
        end
    end    
    k
    if c < d %(d - c) > (log(NS) - log(S))       
        "SPAM ALERT !!!"
        c - d
        spam_count = spam_count + 1;
    else
        "NOT A SPAM"
        c - d
        non_spam_count = non_spam_count + 1;
    end
end
spam_count
non_spam_count