drop DATABASE if exists test_48044;
CREATE DATABASE test_48044;

use test_48044;
drop table if exists test1;

create table test1  (a String, b String NOT NULL, c Int64) engine = CnchMergeTree() order by a;

insert into test1 values ('a', '1', 1);
insert into test1 values ('b', '1', 1);
insert into test1 values ('c', '1', 2);
insert into test1 values ('d', '4', 2);
insert into test1 values ('d', '5', 3);

select count(*), sum(c), count(distinct a), count(distinct b) from test1;

-- test duplicate group by keys
select count(*), sum(c), count(distinct a), count(distinct b), a from test1 group by a order by a;

-- test std::out_of_range exception case
CREATE TABLE aeolus_data_table_8_352783_prod
(
    `row_id_kmtq3k` Int64,
    `p_date` Date,
    `fx_account_id` Nullable(String),
    `user_id` Nullable(String),
    `product_code` Nullable(String),
    `partner_user_id` Nullable(String),
    `partner_code` Nullable(String),
    `person_id` Nullable(String),
    `register_phone` Nullable(String),
    `account_status_code` Nullable(String),
    `account_create_time` Nullable(String),
    `account_delete_time` Nullable(String),
    `credit_id` Nullable(String),
    `out_credit_no` Nullable(String),
    `fund_code` Nullable(String),
    `auto_audit_status` Nullable(String),
    `auto_deny_reason` Nullable(String),
    `all_deny_reason` Nullable(String),
    `manual_audit_status` Nullable(String),
    `manual_deny_reason` Nullable(String),
    `credit_apply_time` Nullable(String),
    `credit_apply_pass_time` Nullable(String),
    `user_source` Nullable(String),
    `credit_create_time` Nullable(String),
    `his_credit_cum` Nullable(Int32),
    `his_credit_info` Array(Nullable(String)),
    `identity` Nullable(String),
    `name` Nullable(String),
    `identity_province` Nullable(String),
    `identity_city` Nullable(String),
    `birth_date` Nullable(String),
    `gender` Nullable(String),
    `nation` Nullable(String),
    `verified_create_time` Nullable(String),
    `submit_host_user_id` Nullable(String),
    `submit_host_app_id` Nullable(String),
    `submit_host_device_id` Nullable(String),
    `submit_create_time` Nullable(String),
    `submit_source` Nullable(String),
    `quota_id` Nullable(String),
    `quota_amount` Nullable(Float64),
    `used_amount` Nullable(Float64),
    `freeze_amount` Nullable(Float64),
    `risk_freeze_amount` Nullable(Float64),
    `daily_rate` Nullable(Float64),
    `annual_rate` Nullable(Float64),
    `monthly_rate` Nullable(Float64),
    `penalty_daily_rate` Nullable(Float64),
    `bill_penalty_daily_rate` Nullable(Float64),
    `loan_product_code` Nullable(String),
    `card_num` Nullable(String),
    `bank_list` Array(Nullable(String)),
    `efc_temp_amount` Nullable(Float64),
    `efc_temp_amount_begin_time` Nullable(String),
    `efc_temp_amount_end_time` Nullable(String),
    `last_temp_amount` Nullable(Float64),
    `last_temp_amount_begin_time` Nullable(String),
    `last_temp_amount_end_time` Nullable(String),
    `last_temp_amount_status_code` Nullable(Float64),
    `used_temp_amount` Nullable(Float64),
    `last_trans_quota_time` Nullable(String),
    `is_trans_quota` Nullable(String),
    `verified_status_code` Nullable(String),
    `ocr_status_code` Nullable(String),
    `ocr_create_time` Nullable(String),
    `avail_quota_amount` Nullable(Float64),
    `is_order` Nullable(String),
    `first_order_date` Nullable(String),
    `first_order_amount` Nullable(Float64),
    `first_order_type` Nullable(String),
    `last_order_date` Nullable(String),
    `last_order_type` Nullable(String),
    `first_order_settle_date` Nullable(String),
    `second_order_type` Nullable(String),
    `order_num` Nullable(Int64),
    `trade_amount_sum` Nullable(Float64),
    `term_trade_amount_sum` Nullable(Float64),
    `real_trade_amount_sum` Nullable(Float64),
    `first_ecom_order_date` Nullable(String),
    `first_ecom_order_amount_date` Nullable(Float64),
    `first_ecom_order_type` Nullable(String),
    `first_ecom_name_new` Nullable(String),
    `first_ecom_vertical_category_new` Nullable(String),
    `first_ecom_vertical_category_ka_new` Nullable(String),
    `ecom_order_num` Nullable(Int64),
    `ecom_trade_amount_sum` Nullable(Float64),
    `ecom_term_trade_amount_sum` Nullable(Float64),
    `ecom_real_trade_amount_sum` Nullable(Float64),
    `last_ecom_order_date` Nullable(String),
    `last_ecom_order_type` Nullable(String),
    `first_credit_order_datedif` Nullable(Int64),
    `last_settle_time` Nullable(String),
    `overdue_status` Nullable(String),
    `history_overdue_status` Nullable(String),
    `zl_amount` Nullable(Int64),
    `zl_amount_begin_time` Nullable(String),
    `zl_amount_end_time` Nullable(String),
    `zl_amount_id` Nullable(String),
    `used_zl_amount` Nullable(Int64),
    `his_is_issue_zl` Nullable(String),
    `is_livedetect` Nullable(String),
    `is_orc` Nullable(String),
    `is_auth` Nullable(String),
    `is_fourelement_dou` Nullable(String),
    `is_submit` Nullable(String),
    `is_amount_success` Nullable(String),
    `fx_person_id` Nullable(String),
    `cust_quality_by_house_es` Nullable(String),
    `cust_quality_by_loan` Nullable(String),
    `credit_amount_version` Nullable(String),
    `cust_quality_by_house_origin` Nullable(String),
    `cust_quality_by_hkyy_origin` Nullable(String),
    `most_use_ip` Nullable(String),
    `location_city` Nullable(String),
    `credit_risk_level` Nullable(String),
    `oceanum_v2` Nullable(String),
    `cust_quality_by_hjovd_amt` Nullable(String),
    `cust_quality_by_loan_orgcnt` Nullable(String),
    `cust_quality_by_hkyy_es` Nullable(String),
    `cust_quality_level_pboc` Nullable(String),
    `location_province` Nullable(String),
    `cust_quality_by_card_es` Nullable(String),
    `first_term_order_date` Nullable(String),
    `oceanum_v1` Nullable(String),
    `author_id` Nullable(String),
    `cust_quality_by_ocean_card` Nullable(String),
    `cust_quality_by_revenue` Nullable(String),
    `cust_quality_by_career` Nullable(String),
    `cust_quality_by_td_d7_applynum` Nullable(String),
    `location_city_level` Nullable(String),
    `cust_quality_by_hjovd_cnt` Nullable(String),
    `ip_list` Nullable(String),
    `first_consume_order_date` Nullable(String),
    `bank_phone` Nullable(String),
    `cust_quality_by_edu_es` Nullable(String),
    `cust_quality_by_card_origin` Nullable(String),
    `zl_amount_version` Nullable(String),
    `brand` Nullable(String),
    `cust_quality_by_ocean_shop` Nullable(String),
    `fico_score` Nullable(String),
    `ip` Nullable(String),
    `first_bill_date` Nullable(String),
    `cust_consume_level` Nullable(String),
    `temp_amount_version` Nullable(String),
    `cust_quality_level_withoutpboc` Nullable(String),
    `cust_quality_by_edu_origin` Nullable(String),
    `last_use_ip` Nullable(String),
    `first_pay_time` Nullable(String),
    `first_lowest_repay_time` Nullable(String),
    `douyin_pay_time` Nullable(String),
    `first_douyin_pay_type` Nullable(String),
    `first_bankcard_pay_time` Nullable(String),
    `first_bill_to_term_time` Nullable(String),
    `gmt_created` Nullable(String),
    `is_dfq_super_white` Nullable(String),
    `first_pay_type` Nullable(String),
    `is_no_pwd` Nullable(String),
    `term_order_num` Nullable(Int64),
    `refund_consume_amt` Nullable(Float64),
    `term_order_amt` Nullable(Float64),
    `repaid_principal` Nullable(Float64),
    `used_ratio` Nullable(Float64),
    `refund_erase_service` Nullable(Float64),
    `douyin_pay_amount` Nullable(Float64),
    `consume_order_amt` Nullable(Float64),
    `commodity_amount` Nullable(Float64),
    `sum_bill_cnt` Nullable(Int64),
    `refund_service` Nullable(Float64),
    `repaid_penalty` Nullable(Float64),
    `success_consume_order_amt` Nullable(Float64),
    `onloan_principal_bal` Nullable(Float64),
    `pay_amount` Nullable(Float64),
    `his_overdue_amt` Nullable(Int64),
    `term_repaid_service_fee` Nullable(Float64),
    `his_overdue_days` Nullable(Int64),
    `refund_term_amt` Nullable(Float64),
    `success_term_order_num` Nullable(Int64),
    `refund_term_cnt` Nullable(Float64),
    `sum_principal_amt` Nullable(Float64),
    `success_consume_order_num` Nullable(Int64),
    `refund_consume_cnt` Nullable(Int64),
    `cur_overdue_days` Nullable(Int64),
    `refund_asset_preservation_fee` Nullable(Float64),
    `consume_order_num` Nullable(Int64),
    `refund_sum_cnt` Nullable(Int64),
    `refund_penalty` Nullable(Float64),
    `cur_overdue_amt` Nullable(Float64),
    `normal_bill_cnt` Nullable(Int64),
    `trade_order_amt` Nullable(Float64),
    `trade_order_num` Nullable(Int64),
    `refund_principal` Nullable(Float64),
    `overdue_bill_cnt` Nullable(Int64),
    `age` Nullable(Int64),
    `no_pwd_quota_amount` Nullable(Float64),
    `early_bill_cnt` Nullable(Int64),
    `residence_city_level` Nullable(String),
    `edu_degree` Nullable(String),
    `user_group_label` Nullable(Int32),
    `age_10` Nullable(String),
    `residence_province_name` Nullable(String),
    `occupation` Nullable(String),
    `user_group_label_name` Nullable(String),
    `credit_amount` Nullable(Int64),
    `entry_ocr_num` Nullable(Int64),
    `first_payment_installment_time` Nullable(String),
    `first_entry_ocr_time` Nullable(String),
    `repurchase_tag` Nullable(String),
    `vertical_category_new` Nullable(String),
    `vertical_category_new_dfq` Nullable(String),
    `his_credit_apply_pass_cum` Nullable(Int32),
    `first_credit_apply_time` Nullable(String),
    `destroy_reason` Nullable(String),
    `chinese_name` Nullable(String),
    `second_category` Nullable(String),
    `bind_fx_account_id` Nullable(String),
    `first_credit_apply_pass_time` Nullable(String),
    `is_used_zl_amount` Nullable(String),
    `first_category` Nullable(String),
    `second_tag` Nullable(String),
    `ec_tag` Nullable(String),
    `first_tag` Nullable(String),
    `user_nr_ltv_level` Nullable(String),
    `second_sec_tag` Nullable(String),
    `account_rank_desc` Nullable(Int32),
    `pre_record_annualrate` Nullable(String),
    `pre_record_organization_id` Nullable(String),
    `min_bind_gmt_created` Nullable(Int64),
    `new_customer_dfq_order_num_30days_score` Nullable(Float64),
    `old_pay_demand_score` Nullable(Float64),
    `pre_record_dailyrate` Nullable(String),
    `pre_record_temp_amount_begin_time` Nullable(String),
    `new_pay_demand_score` Nullable(Float64),
    `pre_record_billpenaltydailyrate` Nullable(String),
    `min_nopw_open_time` Nullable(String),
    `his_batch_no` Nullable(String),
    `pre_record_temp_amount` Nullable(String),
    `product_terms_price_monthly_rate` Nullable(Float64),
    `new_customer_ecom_order_num_30days_score` Nullable(Float64),
    `fxj_first_loan_req_pay_date` Nullable(String),
    `is_fxj_per_overdue` Nullable(String),
    `min_gmt_created` Nullable(Int64),
    `submit_user_id` Nullable(String),
    `is_pre_record_used` Nullable(Int64),
    `pre_record_zx_amount` Nullable(String),
    `pre_record_monthlyrate` Nullable(String),
    `terms_price_monthly_rate` Nullable(Float64),
    `pre_record_penaltydailyrate` Nullable(String),
    `pre_record_expire_time` Nullable(Int64),
    `ops_risk_lvl` Nullable(String),
    `fxj_submit_source` Nullable(String),
    `pre_record_credit_id` Nullable(String),
    `first_order_second_voucher_type` Nullable(String),
    `is_click_driver_banner` Nullable(String),
    `pre_record_temp_amount_end_time` Nullable(String),
    `new_customer_dfq_period_order_num_30days_score` Nullable(Float64),
    `min_nopw_time` Nullable(String),
    `is_fxj_quota_submit` Nullable(String),
    `pre_record_zl_amount_end_time` Nullable(String),
    `min_debit_gmt_created` Nullable(String),
    `first_order_first_voucher_type` Nullable(String),
    `is_pre_record_bind_after_qualified_flag` Nullable(String),
    `pre_record_create_time` Nullable(Int64),
    `his_voucher_name` Nullable(String),
    `old_period_demand_score` Nullable(Float64),
    `pre_record_zl_amount` Nullable(String),
    `pre_record_zl_amount_begin_time` Nullable(String),
    `pre_record_fund_code` Nullable(String),
    `bill_lowest_repay_price_monthly_rate` Nullable(Float64),
    `is_fxj_overdue` Nullable(String),
    `pre_record_decision` Nullable(String),
    `fxj_quota_begin_time` Nullable(String),
    `new_period_demand_score` Nullable(Float64),
    `pre_record_amount` Nullable(String),
    `fxj_quota_submit_time` Nullable(String),
    `fxj_quota_amount` Nullable(String),
    `prior_repay_open_time_first` Nullable(String),
    `is_prior_repay` Nullable(Int32),
    `prior_repay_open_time_last` Nullable(String),
    `is_out_assets_credit` Nullable(String),
    `last_pay_type` Nullable(String),
    `source_name` Nullable(String),
    `out_assets_first_apply_time` Nullable(String),
    `org_list` Nullable(String),
    `payment_installment_cnt` Nullable(String),
    `prior_repay_close_time_first` Nullable(String),
    `out_assets_credit_amount` Nullable(String),
    `lowest_repay_cnt` Nullable(String),
    `last_payment_installment_time` Nullable(String),
    `org_num` Nullable(String),
    `last_pay_time` Nullable(String),
    `first_label` Nullable(String),
    `bill_to_term_cnt` Nullable(String),
    `disable_date` Nullable(String),
    `last_lowest_repay_time` Nullable(String),
    `out_assets_first_credit_time` Nullable(String),
    `last_douyin_pay_time` Nullable(String),
    `prior_repay_open_source_last` Nullable(String),
    `prior_repay_close_time_last` Nullable(String),
    `last_douyin_pay_type` Nullable(String),
    `last_bill_to_term_time` Nullable(String),
    `prior_repay_open_source_first` Nullable(String),
    `disable_all_reason` Nullable(String),
    `product_id` Nullable(String),
    `shop_id` Nullable(String),
    `first_label0` Nullable(String),
    `room_id` Nullable(String),
    `disable_date0` Nullable(String),
    `order_id` Nullable(String),
    `disable_all_reason0` Nullable(String),
    `livedetect_status_code` Nullable(String),
    `before_credit_bytepay_sensitive_v3_score` Nullable(String),
    `user_loyal_zfb_sub_pay_type` Nullable(String),
    `user_loyal_pay_type` Nullable(String),
    `contract_sign_time` Nullable(String),
    `is_sign_contract` Nullable(String),
    `before_credit_ds_ttpay_30_cnt` Nullable(String),
    `before_credit_pay_type` Nullable(String),
    `user_loyal_wx_sub_pay_type` Nullable(String),
    `before_credit_ds_yhk_30_cnt` Nullable(String),
    `before_credit_ds_dyzf_30_cnt` Nullable(String),
    `before_credit_old_pay_bytepay_score` Nullable(String),
    `livedetect_time` Nullable(Int64),
    `user_loyal_dy_sub_pay_type` Nullable(String),
    `before_credit_new_pay_demand_score` Nullable(String),
    `before_credit_ds_dyzf_30_rate` Nullable(String),
    `credit_user_nr_ltv_level` Nullable(String),
    `after_30_ecom_amount_sum` Nullable(Float64),
    `before_30_ecom_amount_sum` Nullable(Float64),
    `first_ecom_amount_sum` Nullable(Float64),
    `first_ecom_order_num` Nullable(String),
    `before_credit_30_ecom_amount_sum` Nullable(Float64),
    `after_30_ecom_order_num` Nullable(String),
    `before_30_ecom_order_num` Nullable(String),
    `ssls_amount` Nullable(Int64),
    `ssls_used_amount` Nullable(Int64),
    `is_grant_ssls` Nullable(Int32),
    `first_no_pwd_quota` Nullable(Int64),
    `last_close_no_pwd_time` Nullable(String),
    `card_bind_source` Nullable(String),
    `first_no_pwd_source` Nullable(String),
    `first_close_no_pwd_time` Nullable(String),
    `is_bind_card_1day_before_credit` Nullable(String),
    `cur_act_ssls_used_amount` Nullable(Int64),
    `all_ssls_amount` Nullable(Int64),
    `all_act_ssls_used_amount` Nullable(Int64),
    `act_ssls_amount` Nullable(Int64),
    `cur_ssls_used_amount` Nullable(Int64),
    `fxj_ocr_status_code` Nullable(String),
    `first_dfq_ocr_create_time` Nullable(String),
    `first_ocr_product` Nullable(String),
    `first_dfq_ocr_update_time` Nullable(String),
    `first_ocr_create_time` Nullable(String),
    `first_fxj_ocr_create_time` Nullable(String),
    `is_repay_date_modify` Nullable(Int64),
    `target_billing_day` Nullable(Int64),
    `target_repay_day` Nullable(Int64),
    `origin_repay_day` Nullable(Int64),
    `last_repay_date_modify_time` Nullable(Int64),
    `origin_billing_day` Nullable(Int64),
    `repay_date_modify_num` Nullable(String),
    `all_lifecycle_first` Nullable(String),
    `ecom_lifecycle_first` Nullable(String),
    `all_lifecycle_third` Nullable(String),
    `all_lifecycle_second` Nullable(String),
    `ecom_lifecycle_second` Nullable(String),
    `ecom_lifecycle_third` Nullable(String),
    `last_credit_source` Nullable(String),
    `cur_credit_bank_num` Nullable(String),
    `user_loyal_wx_sub_pay_type_new` Nullable(String),
    `first_credit_source` Nullable(String),
    `credit_before_debit_bank_num` Nullable(String),
    `user_loyal_dy_sub_pay_type_new` Nullable(String),
    `is_bind_card_debit_1day_before_credit` Nullable(String),
    `first_debit_source` Nullable(String),
    `min_credit_after_source` Nullable(String),
    `user_loyal_pay_type_new` Nullable(String),
    `is_bind_card_credit_1day_before_credit` Nullable(String),
    `user_loyal_zfb_sub_pay_type_new` Nullable(String),
    `cur_debit_bank_num` Nullable(String),
    `last_yq_time` Nullable(String),
    `credit_before_credit_bank_num` Nullable(String),
    `min_credit_after_gmt_created` Nullable(String),
    `last_debit_source` Nullable(String),
    `age_5` Nullable(String),
    `consumption_level` Nullable(String),
    `user_demo_group` Nullable(String),
    `recommend_age` Nullable(String),
    `consumption_level_new` Nullable(String),
    `is_mall_new_user` Nullable(Int64),
    `cust_flag` Nullable(String),
    `first_un_payment_installment_time` Nullable(String),
    `last_installment_time` Nullable(String),
    `last_un_payment_installment_time` Nullable(String),
    `first_yq_time` Nullable(String),
    `cur_xels_used_amount` Nullable(String),
    `all_xels_amount` Nullable(String),
    `effect_card_num` Nullable(String),
    `is_bind_1day_before_date_effect` Nullable(String),
    `xels_used_amount` Nullable(String),
    `is_bind_card_1day_before_credit_effect` Nullable(String),
    `xels_amount` Nullable(String),
    `first_quota_lock_time` Nullable(String),
    `cur_act_xels_used_amount` Nullable(String),
    `lock_status` Nullable(Int64),
    `is_quota_locked_ever` Nullable(Int64),
    `is_quota_locked` Nullable(Int64),
    `is_bind_debit_card_1day_before_credit_effect` Nullable(String),
    `last_quota_lock_time` Nullable(String),
    `all_act_xels_used_amount` Nullable(String),
    `act_xels_amount` Nullable(String),
    `uid_rank_desc` Nullable(String),
    `ranks` Nullable(String),
    `cust_flag0` Nullable(String),
    `uid_rank_asc` Nullable(String),
    `uid_min_credit_apply_pass_time` Nullable(String),
    `uid_min_first_order_date` Nullable(String),
    `first_defer_one_period_repay` Nullable(String),
    `last_defer_one_period_repay` Nullable(String),
    `period_installment_cnt` Nullable(String),
    `is_allow_later_repay` Nullable(String),
    `total_order_percentile_recent_90days` Nullable(String),
    `last_quota_unlock_time` Nullable(String),
    `first_installment_time` Nullable(String),
    `first_quota_unlock_time` Nullable(String),
    `total_amount_percentile_recent_90days` Nullable(String),
    `rank_type` Nullable(String),
    `installment_type` Nullable(String),
    `bdsh_xy_30_trade_amount` Nullable(Int64),
    `bdsh_xy_30_cnt` Nullable(Int64),
    `total_ttpay_30_cnt` Nullable(Int64),
    `bdsh_ttpay_30_cnt` Nullable(Int64),
    `ds_xy_30_trade_amount` Nullable(Int64),
    `ds_ttpay_30_cnt` Nullable(Int64),
    `ds_ttpay_30_trade_amount` Nullable(Int64),
    `total_xy_30_trade_amount` Nullable(Int64),
    `total_ttpay_30_trade_amount` Nullable(Int64),
    `total_xy_30_cnt` Nullable(Int64),
    `bdsh_ttpay_30_trade_amount` Nullable(Int64),
    `ds_xy_30_cnt` Nullable(Int64),
    `repay_cnt_active` Nullable(Int64),
    `repay_cnt` Nullable(Int64),
    `repay_cnt_withhold` Nullable(Int64),
    `repay_cnt_aheadall` Nullable(Int64),
    `repay_cnt_early_settle` Nullable(Int64),
    `repay_cnt_prepayment` Nullable(Int64),
    `first_mx_date` Nullable(String),
    `mx_cnt` Nullable(Int64),
    `is_huabei` Nullable(String),
    `residence_city_name` Nullable(String),
    `is_master` Nullable(String),
    `is_sign_loan` Nullable(String),
    `after_first_trade_30_bdsh_creditpay_avg_amount` Nullable(Float64),
    `after_first_trade_30_bdsh_cnt` Nullable(Int64),
    `before_first_trade_30_bdsh_avg_amount` Nullable(Float64),
    `before_first_trade_30_bdsh_cnt` Nullable(Int64),
    `period12_discount_ratio` Nullable(Int64),
    `period6_discount_ratio` Nullable(Int64),
    `tx_amount` Nullable(Float64),
    `last_mx_date` Nullable(String),
    `tx_cnt` Nullable(Int64),
    `last_tx_date` Nullable(String),
    `period3_discount_ratio` Nullable(Int64),
    `mx_amount` Nullable(Float64),
    `is_sign_withhold` Nullable(Int32),
    `first_tx_date` Nullable(String),
    `first_bill_date0` Nullable(String),
    `is_equal_phone_num` Nullable(Int32),
    `period24_discount_ratio` Nullable(Int64),
    `fxj_livedetect_status_code` Nullable(Int32),
    `pay_livedetect_status_code` Nullable(Int32),
    `first_subscription_time` Nullable(Int64),
    `max_quota_limit_set_time` Nullable(Int64),
    `first_subscription_source` Nullable(String),
    `last_subscription_source` Nullable(String),
    `backup_org_list` Array(Nullable(String)),
    `min_quota_limit_set_time` Nullable(Int64),
    `master_org_id` Nullable(String),
    `pay_ocr_status_code` Nullable(Int32),
    `quota_limit_amount` Nullable(String),
    `last_subscription_time` Nullable(Int64),
    `subscription_status` Nullable(Int32),
    `is_quota_limit` Nullable(Int32),
    `bind_card_before_loan_status` Nullable(Int64),
    `backup_org_num` Nullable(Int32),
    `term_risk_level` Nullable(String),
    `cust_list_label` Nullable(String),
    `dyyf_cust_seg_v3` Nullable(String),
    `payment_installment_risk_level` Nullable(String),
    `last_30_fffq_cnt` Nullable(String),
    `dyyf_cust_seg` Nullable(String),
    `credit_tag` Nullable(String),
    `account_label_json` Nullable(String),
    `pay_livedetect_sync_status` Nullable(Int32),
    `payment_installment_lifecycle_type` Nullable(String),
    `last_order_installment_time` Nullable(String),
    `first_order_installment_time` Nullable(String),
    `first_yq_type` Nullable(String),
    `ua_creditpay_high_natural_will` Nullable(Float32),
    `last_30d_main_page_pv` Nullable(Int64),
    `last_30d_main_page_days` Nullable(Int64)
)
ENGINE = CnchMergeTree() order by row_id_kmtq3k;

SELECT
    count(multiIf(isNotNull(credit_apply_pass_time) AND (auto_audit_status = '3'), submit_host_user_id, NULL)) AS _count_1700010380910,
    countDistinct(multiIf(isNotNull(CAST(first_term_order_date, 'Nullable(Date)')), submit_host_user_id, NULL)) AS _1700018901243,
    countDistinct(multiIf(isNotNull(CAST(to_date(first_payment_installment_time), 'Nullable(Date)')), submit_host_user_id, NULL)) AS _1700018805062,
    countDistinct(multiIf(isNotNull(CAST(first_term_order_date, 'Nullable(Date)')) OR (CAST(first_yq_time, 'Nullable(Date)') > '2021-07-01'), submit_host_user_id, NULL)) / countDistinct(multiIf(auto_audit_status = '3', fx_account_id, NULL)) AS _1700021754761,
    uniq(multiIf(dateDiff(CAST(first_order_date, 'Nullable(Date)'), CAST(first_term_order_date, 'Nullable(Date)')) <= 30, fx_account_id, NULL)) / uniq(multiIf(is_order = '1', multiIf(isNotNull(credit_apply_pass_time) AND (auto_audit_status = '3'), submit_host_user_id, NULL), NULL)) AS _1700018902349
FROM aeolus_data_table_8_352783_prod
WHERE ((p_date >= '2024-06-05') AND (p_date <= '2024-06-05')) AND (auto_audit_status = '3') AND (uid_rank_desc = '1')
LIMIT 1000;

CREATE TABLE app_instant_partner_shop_di
(
    `partner_id` Int64,
    `partner_name` String,
    `root_shop_id` Int64,
    `root_shop_name` String,
    `shop_logo_uri` String,
    `ofo_commission_amt` Decimal(38, 6),
    `ofo_live_commission_amt` Decimal(38, 6),
    `pay_amt` Decimal(38, 6),
    `pay_prod_cnt` Int64,
    `prod_expose_uids` Nullable(SketchBinary),
    `prod_click_uids` Nullable(SketchBinary),
    `refund_amt` Decimal(38, 6),
    `prod_reture_ord_cnt_3d` Int64,
    `accept_ord_cnt` Int64,
    `bad_comment_ord_cnt_3d` Int64,
    `complain_ord_cnt_7d` Int64,
    `pay_ord_cnt` Int64,
    `date_type` String,
    `date` Date
)
ENGINE = CnchMergeTree
PARTITION BY date
ORDER BY (partner_id, root_shop_id, date_type, intHash64(partner_id));

SELECT
    sum(ofo_commission_amt + ofo_live_commission_amt) AS commission_amt,
    sum(pay_amt) AS pay_amt_cnt,
    sum(pay_prod_cnt) AS pay_prod_cnt,
    countDistinct(IF(pay_amt > 0, root_shop_id, NULL)) AS has_paid_shop_cnt,
    hllSketchEstimate(12, 1)(prod_click_uids) / hllSketchEstimate(12, 1)(prod_expose_uids) AS click_expose_rate,
    sum(refund_amt) AS refund_amt
FROM app_instant_partner_shop_di
WHERE ((date >= '2024-05-24') AND (date <= '2024-05-30')) AND (partner_id = 7368703292081193255) AND (date_type = '1d');

CREATE TABLE ads_agroup_24year_brand_stat_df
(
    `date_time` String,
    `brand_id` Int64,
    `brand_name` Nullable(String),
    `brand_s_level` Nullable(String),
    `shop_settle_type` String,
    `first_mgt_cate` Nullable(String),
    `second_mgt_cate` Nullable(String),
    `cate_attribution` Nullable(String),
    `tier` Nullable(String),
    `tier_name` Nullable(String),
    `brand_layer` Nullable(String),
    `strategy_brand_struct` Nullable(String),
    `strategy_cate_props` Nullable(String),
    `strategy_agroup_industry` Nullable(String),
    `strategy_second_vbline_id` Nullable(Int64),
    `strategy_cate_attribution` Nullable(String),
    `strategy_tier` Nullable(String),
    `is_gmv_task` Int8,
    `is_mall_shelf_task` Int8,
    `is_low_brand_task` Int8,
    `is_high_price_task` Int8,
    `op_emp_id` Nullable(Int64),
    `op_emp_name` Nullable(String),
    `op_emp_email` Nullable(String),
    `second_vbline_id` Nullable(Int64),
    `second_vbline_name` Nullable(String),
    `third_vbline_id` Nullable(Int64),
    `third_vbline_name` Nullable(String),
    `fourth_vbline_id` Nullable(Int64),
    `fourth_vbline_name` Nullable(String),
    `slice_id` UInt32,
    `td_gmv` Int64,
    `gmv` Int64,
    `history_gmv` Int64,
    `history_td_gmv` Int64,
    `p_date` Date,
    `date_type` String,
    `platform` Int32,
    `op_td_gmv` Int64,
    `strategy_agroup_industry_name` Nullable(String),
    `strategy_first_vbline_name` Nullable(String),
    `first_vbline_name` Nullable(String),
    `first_vbline_id` Nullable(Int64),
    `strategy_first_vbline_id` Nullable(Int64)
)
ENGINE = CnchMergeTree
PARTITION BY (p_date, date_type, platform)
CLUSTER BY slice_id INTO 24 BUCKETS SPLIT_NUMBER 96
ORDER BY (date_time, brand_id, shop_settle_type, slice_id, p_date, date_type, platform, intHash64(slice_id));

SELECT
    countDistinct(brand_id) AS brand_nums,
    sumIf(gmv, platform = 1) AS douyin_index,
    sumIf(gmv, platform IN (2, 4)) AS outer_index
FROM ads_agroup_24year_brand_stat_df
WHERE (p_date = '2024-06-06') AND (date_type = 'month') AND ((platform IN (2, 4)) OR (platform = 1)) AND (date_time IN ('20221130', '20221231', '20230131', '20230228', '20230331', '20230430')) AND (brand_layer IN ('0份额品牌', '极劣势品牌', '劣势品牌', '胶着品牌', '优势品牌')) AND (shop_settle_type IN ('旗舰店', '经销商')) AND (strategy_first_vbline_id = 11230509000002) AND isNotNull(strategy_second_vbline_id) AND isNotNull(strategy_agroup_industry_name)