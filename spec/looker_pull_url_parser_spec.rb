require "spec_helper"

describe LookerPull::UrlParser do
  let(:subject){LookerPull::UrlParser.new(items_looker_url)}
  let(:items_looker_url){"https://looker.thredup.com:9999/explore/thredup/items?fields=items_id,items_concierge_bag_id,orders_id,items_gender&f[items_id]=to+999999&sorts=items_id&limit=5&title=Item+Pull"}
  it "extracts the query params automatically" do
    subject.query_params.should == "fields=items_id,items_concierge_bag_id,orders_id,items_gender&f[items_id]=to+999999&sorts=items_id&limit=5&title=Item+Pull"
  end
  it "extracts the base url automatically" do
    subject.base_url.should == "https://looker.thredup.com:9999/explore/thredup/items"
  end
  it "extracts the model name" do
    subject.parse_model
    subject.model.should == "items"
  end
  it "extracts the dictionary name" do
    subject.parse_dictionary
    subject.dictionary.should == "thredup"
  end
  it "extracts fields" do
    subject.parse_fields
    subject.fields.should == %w{items_id items_concierge_bag_id orders_id items_gender}
  end
  it "extracts filters" do
    subject.parse_filters
    subject.filters.should == {"items_id" => "to+999999"}
  end
  it "extracts sorts" do
    subject.parse_sorts
    subject.sorts.should == "items_id"
  end 

  it "extracts limit" do
    subject.parse_limit
    subject.limit.should == "5"
  end 

  it "extracts title" do
    subject.parse_title
    subject.title.should == "Item+Pull"
  end 

end



