=begin
  This file is part of ViewpointSPWS; the Ruby library for Microsoft Sharepoint Web Services.

  Copyright © 2011 Dan Wanek <dan.wanek@gmail.com>

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
=end

# This class represents the Sharepoint Lists Web Service.
# @see http://msdn.microsoft.com/en-us/library/ms774654(v=office.12).aspx
class Viewpoint::SPWS::Lists
  include Viewpoint::SPWS::WebServiceBase

  def initialize(spcon)
    @default_ns  = 'http://schemas.microsoft.com/sharepoint/soap/'
    @ws_endpoint = '_vti_bin/Lists.asmx'
    super
  end

  # Returns all the lists for a Sharepoint site.
  # @param [Boolean] show_hidden Whether or not to show hidden lists. Default = false
  # @see http://msdn.microsoft.com/en-us/library/lists.lists.getlistcollection(v=office.12).aspx
  def get_list_collection(show_hidden = false)
    soapmsg = build_soap_envelope do |type, builder|
      if(type == :header)
      else
        builder.GetListCollection {
          builder.parent.default_namespace = @default_ns
        }
      end
    end
    soaprsp = Nokogiri::XML(send_soap_request(soapmsg.doc.to_xml))
    ns = {"xmlns"=> @default_ns}
    lists = []
    soaprsp.xpath('//xmlns:Lists/xmlns:List', ns).each do |l|
      lists << List.new(l)
    end
    if(!show_hidden)
      lists.reject! do |i|
        i.hidden?
      end
    end
    lists
  end
  alias :get_lists :get_list_collection


  # Retrieve a specific Sharepoint List
  # @see http://msdn.microsoft.com/en-us/library/lists.lists.getlist(v=office.12).aspx
  # @param [String] list title or the GUID for the list
  # @return [Viewpoint::SPWS::List]
  def get_list(list)
    soapmsg = build_soap_envelope do |type, builder|
      if(type == :header)
      else
        builder.GetList {
          builder.parent.default_namespace = @default_ns
          builder.listName(list)
        }
      end
    end
    soaprsp = Nokogiri::XML(send_soap_request(soapmsg.doc.to_xml))
    ns = {"xmlns"=> @default_ns}
    List.new(soaprsp.xpath('//xmlns:GetListResult/xmlns:List', ns).first)
  end

  # Get List Items based on certain parameters
  # @see http://msdn.microsoft.com/en-us/library/lists.lists.getlistitems(v=office.12).aspx
  # @param [String] list title or the GUID for the list
  # @param [Hash] parms
  #   :view_name GUID for the view surrounded by curly braces 
  def get_list_items(list, parms = {})
    soapmsg = build_soap_envelope do |type, builder|
      if(type == :header)
      else
        builder.GetListItems {
          builder.parent.default_namespace = @default_ns
          builder.listName(list)
          builder.viewName(parms[:view_name])
        }
      end
    end
    soaprsp = Nokogiri::XML(send_soap_request(soapmsg.doc.to_xml))
    ns = {"xmlns"=> @default_ns}
    ns = {'xmlns:z' => "#RowsetSchema"}
    items = []
    soaprsp.xpath('//z:row', ns).each do |li|
      items << ListItem.new(li)
    end
    items
  end
end
