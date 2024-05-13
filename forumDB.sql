create database forum;
use  forum;

create table users (
user_id int auto_increment
primary key,
username varchar(255)
not null,
password varchar(255) not
null,
email varchar(255) not
null,
registration_date
timestamp default
current_timestamp
);

create table topics (
topic_id int primary key
auto_increment,
title varchar(255) not null,
description text not null,
creation_date datetime not
null default current_timestamp,
user_id int not null,
foreign key (user_id)
references users
(user_id)
);

create table posts (
post_id int primary key
auto_increment,
content text not null,
creation_date datetime
not null default
current_timestamp,
topic_id int not null,
user_id int not null,
foreign key (topic_id)
references topics
(topic_id),
foreign key (user_id)
references users
(user_id)
);

create table private_messages
(
message_id int primary key
auto_increment,
sender_id int not null,
recipient_id int not null,
subject varchar(255) not null,
content text not null,
sent_date datetime not null
default current_timestamp,
foreign key (sender_id)
references users
(user_id),
foreign key (recipient_id)
references users
(user_id));

create table comments (
comment_id int primary
key auto_increment,
content text not null,
creation_date datetime not
null default
current_timestamp,
post_id int not null,
user_id int not null,
foreign key (post_id)
references posts
(post_id),
foreign key (user_id)
references users
(user_id)
);

create table likes (
like_id int auto_increment
primary key,
post_id int not null,
user_id int not null,
like_date timestamp
default current_timestamp,
foreign key (post_id)
references posts(post_id),
foreign key (user_id)
references users(user_id)
);

create table notifications (
notification_id int
auto_increment primary key,
user_id int not null,
message text not null,
creation_date datetime not
null default
current_timestamp,
foreign key (user_id)
references users(user_id)
);

INSERT INTO users (username, password, email, registration_date)
VALUES
('john.doe', 'smtheasy', 'john.doe@example.com', curdate()),
('jane.smith', 'smith444', 'jane.smith@example.com', curdate()),
('alice_coder', 'lovejs0', 'alice.coder@email.com', date_sub(curdate(), interval 2 day)),
('bookworm_david', 'books4life', 'david.reader@gmail.com', date_sub(curdate(), interval 1 week)),
('chef_olivia', 'chimichuri201', 'olivia_garcia@cooking.com', date_sub(curdate(), interval 3 month)),
('travelholic_william', 'ineedavacation', 'william.travels@yahoo.com', date_sub(curdate(), interval 1 year)),
('gamergirl_emily', 'minecraft85v', 'emily.gamer@hotmail.com', date_sub(curdate(), interval 6 month)),
('music_lover_noah', 'jazzz', 'noah.music@live.com', date_sub(curdate(), interval 2 week)),
('art_enthusiast_sophia', '420picaso', 'sophia.art@outlook.com', curdate()),
('lifehacker99', 'verystr0ngpassw0rd', 'lifehacker99@tips.com', date_sub(curdate(), interval 1 month));

INSERT INTO topics (title, description, user_id)
VALUES
('Welcome', 'Introduction to the forum', 1),
('Programming Help', 'Discuss coding challenges', 1),
('Book Recommendations', 'Share your favorite reads', 3),
('Cooking Tips', 'Swap recipes and cooking advice', 4),
('Travel Experiences', 'Share travel recommendations', 1);

INSERT INTO posts (topic_id, content, user_id)
VALUES
(1, 'Hello, everyone! Welcome to our forum!', 1),
(1, 'This forum looks great!', 7),
(2, 'I need help with a JavaScript function.', 2),
(3, 'Just finished reading "Pride and Prejudice"!', 3),
(4, 'Looking for a quick and easy weeknight meal.', 4),
(4, 'Any recommendations for a vegetarian pizza recipe?', 5),
(5, 'Planning a trip to Italy next summer.', 9);

INSERT INTO comments (post_id, content, user_id)
VALUES
(1, 'Great post, thanks for sharing!', 2),
(2, 'I think I can help you with that JavaScript function.', 5),
(3, 'I love "Pride and Prejudice" too!', 4),
(4, 'That lentil soup sounds delicious!', 8),
(5, 'Italy is amazing, you will have a great time!', 6);

insert into likes (post_id, user_id)
values
(1, 2),
(1, 3),
(2, 4),
(2, 5),
(3, 6),
(4, 7),
(4, 8),
(5, 9);

INSERT INTO private_messages (sender_id, recipient_id, subject, content, sent_date)
VALUES
(1, 2, 'Hello Jane', 'Hi Jane! Just wanted to say hello and see how you\'re doing. Let me know if you need anything!', date_sub(curdate(), interval 2 day)),
(2, 1, 'Re: Hello John', 'Hi John! Thanks for reaching out. I\'m doing well, just busy with work. Let\'s catch up soon!', date_sub(curdate(), interval 1 day)),
(3, 5, 'Question about JavaScript', 'Hey! I have a question about JavaScript closures. Can you help me understand how they work?', date_sub(curdate(), interval 1 week)),
(5, 3, 'Re: Question about JavaScript', 'Sure thing! Closures can be a bit tricky at first, but I\'ll do my best to explain. Let\'s chat about it!', date_sub(curdate(), interval 6 day)),
(7, 1, 'Re: Welcome to the Forum', 'Thanks! I\'m glad you like it. Let me know if you have any suggestions for improvement.', date_sub(curdate(), interval 1 day)),
(4, 7, 'Re: Welcome to the Forum', 'Hi Emily! I agree, this forum has a nice layout. Looking forward to engaging in discussions with everyone!', date_sub(curdate(), interval 2 day)),
(10, 1, 'New Feature Suggestion', 'Hey John! I have an idea for a new feature on the forum. Can we discuss it sometime this week?', date_sub(curdate(), interval 3 day)),
(1, 10, 'Re: New Feature Suggestion', 'Sure thing, Sophia! Let\'s schedule a meeting to talk about it. How about tomorrow afternoon?', date_sub(curdate(), interval 2 day));

SELECT u.user_id, u.username, u.email
FROM users u
WHERE email LIKE '%mail%';

select u.user_id, u.username, count(p.post_id) as post_count
from users u
left join posts p on u.user_id = p.user_id
group by u.user_id, u.username;

select
u.username,
count(distinct p.post_id) as total_posts,
count(distinct c.comment_id) as total_comments
from users u
inner join posts p on u.user_id = p.user_id
inner join comments c on p.post_id = c.post_id
group by u.username;

select p.post_id,
p.content,
count(distinct l.like_id) as total_likes,
count(distinct c.comment_id) as total_comments
from posts p
left join likes l on p.post_id = l.post_id
left join comments c on p.post_id = c.post_id
group by p.post_id, p.content;

select username, total_posts
from users
join (
select user_id, count(*) as total_posts
from posts
group by user_id
order by total_posts desc
limit 3
) as userposts on users.user_id = userposts.user_id;

select
t.topic_id, t.title, count(c.comment_id) as comment_count
from
topics t
left join
posts p on t.topic_id = p.topic_id
left join
comments c on p.post_id = c.post_id
group by t.topic_id , t.title
order by comment_count desc
limit 1;

delimiter //
create trigger notify_new_message
after insert on private_messages
for each row
begin
declare recipient_user_id int;
declare message_content text;
select recipient_id, content into recipient_user_id, message_content from
private_messages where message_id = new.message_id;
insert into notifications (user_id, message, creation_date)
values (recipient_user_id, message_content, now());
end//
delimiter;

-- 8 test
insert into private_messages (sender_id, recipient_id, subject, content, sent_date)
values
(1, 1, &quot;testingtrigger&quot;, &quot;lets test it out!&quot;, curdate());

DELIMITER //
CREATE PROCEDURE ShowUserProfileWithStats()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE userid INT;
    DECLARE username VARCHAR(255);
    DECLARE useremail VARCHAR(255);
    DECLARE usertopics INT;
    DECLARE userposts INT;
    DECLARE usercomments INT;
    DECLARE userlikes INT;
    
    DECLARE usercursor CURSOR FOR
        SELECT
            u.user_id,
            u.username,
            u.email,
            COUNT(DISTINCT t.topic_id) AS topics_created,
            COUNT(DISTINCT p.post_id) AS posts_created,
            COUNT(DISTINCT c.comment_id) AS comments_created,
            COUNT(DISTINCT l.like_id) AS total_likes_received
        FROM
            users u
            LEFT JOIN topics t ON u.user_id = t.user_id
            LEFT JOIN posts p ON u.user_id = p.user_id
            LEFT JOIN comments c ON u.user_id = c.user_id
            LEFT JOIN likes l ON p.post_id = l.post_id
        GROUP BY
            u.user_id;
            
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN usercursor;
    read_loop: LOOP
        FETCH usercursor INTO userid, username, useremail, usertopics, userposts, usercomments, userlikes;
        IF done THEN
            LEAVE read_loop;
        END IF;
        
        SELECT CONCAT('user id: ', userid,
                      ', username: ', username,
                      ', email: ', useremail,
                      ', topics created: ', usertopics,
                      ', posts created: ', userposts,
                      ', comments created: ', usercomments,
                      ', total likes received: ', userlikes) AS user_profile;
    END LOOP;
    CLOSE usercursor;
END //
DELIMITER ;

