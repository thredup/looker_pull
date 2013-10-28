require "spec_helper"

describe LookerPull::Downloader do
  let(:items_pull_url){"https://looker.thredup.com:9999/explore/thredup/items?fields=items_id,items_concierge_bag_id,orders_id,items_gender,items_is_juniors,items_purchased,items_listed_now,items_listed_ever,items_in_inventory,items_no_longer_in_inventory,current_state_min_date,items_listed_date,items_purchased_date,items_price,items_category_id,items_brand_id,items_product_id,items_location,items_state,items_created_date,items_upfront_payout,items_photographer_name,items_photo_station_name,items_itemizer_name,items_sorter_name,items_views,items_original_item_id,items_new_with_tags,items_packer_name,sizings_id,items_quality_code,items_reason,items_refund_reason,item_prices_original_price,item_prices_msrp&sorts=items_id&limit=5&title=Operations Metrics Item Pull All"}
  let(:basic_downloader){LookerPull::Downloader.new(items_pull_url,{max_rows: 10})}
  let(:items_pull_formater){LookerPull::Formatter.new({
    currency_fields: %w{
      concierge_bags_bag_revenue
      concierge_bags_amount_awarded
      orders_amount
      orders_credits
      orders_cashoutable_credits_used
      orders_noncashoutable_credits_used
      orders_discounts_used
      orders_discount
      orders_gross_item_revenue
      orders_gross_shipping_revenue
      items_price
      item_prices_original_price
      items_upfront_payout
    },
    header_mappings: [
      {
        applicable_fields: [:current_state_min_date],
        prepend: "items_"
      },
      {
        applicable_fields: [:orders_amount],
        append: "_charged"
      },
      {
        applicable_fields: [:orders_gross_shipping_revenue],
        append: "_less_free_shipping"
      },
      {
        applicable_fields: [:orders_all_orders_repeat_buy, :orders_bag_included, :orders_items_included, :items_is_juniors, :items_purchased, :items_listed_now, :items_listed_ever, :items_in_inventory, :items_no_longer_in_inventory],
        append: "_(yes_/_no)"
      }
    ],
    header_gsubs: {
      "_" => " "
    }
  })}

  let(:downloader_with_formatter){LookerPull::Downloader.new(items_pull_url,{max_rows: 10, formatter: items_pull_formater})}

  describe "basic integration tests" do
    it "loads a basic item pull" do
      VCR.use_cassette('basic_downloader_fetch') do
        d = basic_downloader
        d.fetch
      end
    end

    it "loads a basic item pull and processes it with a formatter" do
      VCR.use_cassette('basic_downloader_fetch') do
        d = downloader_with_formatter
        d.fetch
      end
    end

    
  end
end