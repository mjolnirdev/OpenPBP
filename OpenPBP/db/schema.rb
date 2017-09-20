# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 13) do

  create_table "accounts", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string "name"
    t.string "surname"
    t.string "email"
    t.string "crypted_password"
    t.string "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "campaign_memberships", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer "user_id"
    t.integer "campaign_id"
    t.boolean "gm", default: false
    t.boolean "owner", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["campaign_id"], name: "index_campaign_memberships_on_campaign_id"
    t.index ["user_id"], name: "index_campaign_memberships_on_user_id"
  end

  create_table "campaigns", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string "cid"
    t.string "slug"
    t.string "title"
    t.text "description"
    t.string "image"
    t.boolean "archived", default: false
    t.string "join_link"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cid"], name: "index_campaigns_on_cid"
    t.index ["join_link"], name: "index_campaigns_on_join_link"
    t.index ["slug"], name: "index_campaigns_on_slug"
  end

  create_table "chapters", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer "campaign_id"
    t.string "slug"
    t.string "title"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["campaign_id"], name: "index_chapters_on_campaign_id"
    t.index ["slug"], name: "index_chapters_on_slug"
  end

  create_table "characters", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer "campaign_id"
    t.integer "user_id"
    t.string "charid"
    t.string "name"
    t.string "portrait"
    t.text "bio"
    t.boolean "gm", default: false
    t.boolean "default", default: false
    t.boolean "retired", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["campaign_id"], name: "index_characters_on_campaign_id"
    t.index ["charid"], name: "index_characters_on_charid"
    t.index ["user_id"], name: "index_characters_on_user_id"
  end

  create_table "chat_messages", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer "campaign_id"
    t.integer "user_id"
    t.string "name"
    t.text "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["campaign_id"], name: "index_chat_messages_on_campaign_id"
    t.index ["user_id"], name: "index_chat_messages_on_user_id"
  end

  create_table "notes", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string "nid"
    t.integer "post_id"
    t.integer "campaign_id"
    t.integer "user_id"
    t.string "slug"
    t.string "title"
    t.text "note"
    t.boolean "public_note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["campaign_id"], name: "index_notes_on_campaign_id"
    t.index ["nid"], name: "index_notes_on_nid"
    t.index ["post_id"], name: "index_notes_on_post_id"
    t.index ["slug"], name: "index_notes_on_slug"
    t.index ["user_id"], name: "index_notes_on_user_id"
  end

  create_table "post_rolls", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer "user_id"
    t.integer "post_id"
    t.text "rolled_dice"
    t.text "results"
    t.string "modifier"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_post_rolls_on_post_id"
    t.index ["user_id"], name: "index_post_rolls_on_user_id"
  end

  create_table "posts", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string "pid"
    t.integer "scene_id"
    t.integer "user_id"
    t.integer "character_id"
    t.text "post"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["character_id"], name: "index_posts_on_character_id"
    t.index ["pid"], name: "index_posts_on_pid"
    t.index ["scene_id"], name: "index_posts_on_scene_id"
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "replies", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer "post_id"
    t.integer "user_id"
    t.integer "character_id"
    t.string "rid"
    t.text "reply"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["character_id"], name: "index_replies_on_character_id"
    t.index ["post_id"], name: "index_replies_on_post_id"
    t.index ["rid"], name: "index_replies_on_rid"
    t.index ["user_id"], name: "index_replies_on_user_id"
  end

  create_table "reply_rolls", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer "reply_id"
    t.integer "user_id"
    t.text "rolled_dice"
    t.text "results"
    t.string "modifier"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["reply_id"], name: "index_reply_rolls_on_reply_id"
    t.index ["user_id"], name: "index_reply_rolls_on_user_id"
  end

  create_table "scenes", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer "chapter_id"
    t.string "slug"
    t.string "title"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chapter_id"], name: "index_scenes_on_chapter_id"
    t.index ["slug"], name: "index_scenes_on_slug"
  end

  create_table "users", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string "uid"
    t.string "email"
    t.string "display_name"
    t.string "password_hash"
    t.boolean "email_confirmed"
    t.boolean "password_reset"
    t.string "password_link"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["uid"], name: "index_users_on_uid"
  end

end
