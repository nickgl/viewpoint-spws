# -*- coding: utf-8 -*-
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
class Viewpoint::SPWS::Websvc::Permissions
  include Viewpoint::SPWS::Websvc::WebServiceBase

  def initialize(spcon)
    @default_ns  = 'http://schemas.microsoft.com/sharepoint/soap/directory/'
    @ws_endpoint = '_vti_bin/Permissions.asmx'
    super
  end


  # Retrieve the Permissions for a document
  # @param [String] document file ref
  # @return [Viewpoint::SPWS::List]
  def get_permissions(document)
    soapmsg = build_soap_envelope do |type, builder|
      if(type == :header)
      else
        builder.GetPermissionCollection {
          builder.parent.default_namespace = @default_ns
          builder.objectName(document)
          builder.objectType('Web')
        }
      end
    end
    soaprsp = Nokogiri::XML(send_soap_request(soapmsg.doc.to_xml))
    permissions = []
    ns = {"xmlns"=> @default_ns}
    soaprsp.xpath('//xmlns:GetPermissionCollectionResult/xmlns:GetPermissionCollection/xmlns:Permissions/xmlns:Permission', ns).each do |l|
      permissions << new_permission(l)
    end

    permissions

  end

  private

  # Parse the SOAP Response and return an appropriate List type
  def new_permission(xmllist)
    Types::Permission.new(self, xmllist)
  end


end
