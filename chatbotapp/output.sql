BEGIN;
--
-- Create model MyUser
--
CREATE TABLE "chatbot_myuser" ("id" bigserial NOT NULL PRIMARY KEY, "password" varchar(128) NOT NULL, "last_login" timestamp with time zone NULL, "is_superuser" boolean NOT NULL, "username" varchar(150) NOT NULL UNIQUE, "first_name" varchar(150) NOT NULL, "last_name" varchar(150) NOT NULL, "is_staff" boolean NOT NULL, "is_active" boolean NOT NULL, "date_joined" timestamp with time zone NOT NULL, "email" varchar(254) NOT NULL UNIQUE);
CREATE TABLE "chatbot_myuser_groups" ("id" bigserial NOT NULL PRIMARY KEY, "myuser_id" bigint NOT NULL, "group_id" integer NOT NULL);
CREATE TABLE "chatbot_myuser_user_permissions" ("id" bigserial NOT NULL PRIMARY KEY, "myuser_id" bigint NOT NULL, "permission_id" integer NOT NULL);
--
-- Create model QnA
--
CREATE TABLE "chatbot_qna" ("id" bigserial NOT NULL PRIMARY KEY, "question" varchar(300) NOT NULL, "answer" text NOT NULL, "user_id" bigint NOT NULL);
CREATE INDEX "chatbot_myuser_username_30e1a406_like" ON "chatbot_myuser" ("username" varchar_pattern_ops);
CREATE INDEX "chatbot_myuser_email_f7313c42_like" ON "chatbot_myuser" ("email" varchar_pattern_ops);
ALTER TABLE "chatbot_myuser_groups" ADD CONSTRAINT "chatbot_myuser_groups_myuser_id_group_id_75aa2845_uniq" UNIQUE ("myuser_id", "group_id");
ALTER TABLE "chatbot_myuser_groups" ADD CONSTRAINT "chatbot_myuser_groups_myuser_id_7d23054d_fk_chatbot_myuser_id" FOREIGN KEY ("myuser_id") REFERENCES "chatbot_myuser" ("id") DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE "chatbot_myuser_groups" ADD CONSTRAINT "chatbot_myuser_groups_group_id_986a86a8_fk_auth_group_id" FOREIGN KEY ("group_id") REFERENCES "auth_group" ("id") DEFERRABLE INITIALLY DEFERRED;
CREATE INDEX "chatbot_myuser_groups_myuser_id_7d23054d" ON "chatbot_myuser_groups" ("myuser_id");
CREATE INDEX "chatbot_myuser_groups_group_id_986a86a8" ON "chatbot_myuser_groups" ("group_id");
ALTER TABLE "chatbot_myuser_user_permissions" ADD CONSTRAINT "chatbot_myuser_user_perm_myuser_id_permission_id_cabb4023_uniq" UNIQUE ("myuser_id", "permission_id");
ALTER TABLE "chatbot_myuser_user_permissions" ADD CONSTRAINT "chatbot_myuser_user__myuser_id_1a8c43d0_fk_chatbot_m" FOREIGN KEY ("myuser_id") REFERENCES "chatbot_myuser" ("id") DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE "chatbot_myuser_user_permissions" ADD CONSTRAINT "chatbot_myuser_user__permission_id_82b14749_fk_auth_perm" FOREIGN KEY ("permission_id") REFERENCES "auth_permission" ("id") DEFERRABLE INITIALLY DEFERRED;
CREATE INDEX "chatbot_myuser_user_permissions_myuser_id_1a8c43d0" ON "chatbot_myuser_user_permissions" ("myuser_id");
CREATE INDEX "chatbot_myuser_user_permissions_permission_id_82b14749" ON "chatbot_myuser_user_permissions" ("permission_id");
ALTER TABLE "chatbot_qna" ADD CONSTRAINT "chatbot_qna_user_id_34b6d517_fk_chatbot_myuser_id" FOREIGN KEY ("user_id") REFERENCES "chatbot_myuser" ("id") DEFERRABLE INITIALLY DEFERRED;
CREATE INDEX "chatbot_qna_user_id_34b6d517" ON "chatbot_qna" ("user_id");
COMMIT;
