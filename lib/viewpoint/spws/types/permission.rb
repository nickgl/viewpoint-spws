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

# This class represents a Sharepoint Permission
class Viewpoint::SPWS::Types::Permission
  include Viewpoint::SPWS::Types

  attr_reader :memberid, :mask, :member_is_user, :member_global, :user_login, :group_name

  def initialize(ws, xml)
    @ws             = ws
    @memberid       = xml['MemberID']
    @mask           = xml['Mask']
    @member_is_user = xml['MemberIsUser']
    @member_global  = xml['MemberGlobal']
    @user_login     = xml['UserLogin']
    @group_name     = xml['GroupName']
  end
end
