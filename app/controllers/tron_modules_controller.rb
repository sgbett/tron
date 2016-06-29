class TronModulesController < ApplicationController
  
  HOST = 'https://beta.portfolioonline.co.uk'
  CLIENT_ID = '33facf6e3c3786c0ad1c45828c57129fa43178064308e1456023a73a675308d1'
  CLIENT_SECRET = '829d0e0e519404b80316a4b290c40bc2af188d38ecfc02f1e63dbdf6463cc4ec'
  
  def show
    #callback url
      if code = params[:code]
        response = RestClient.post "#{HOST}/oauth/token", {client_id: CLIENT_ID, client_secret: CLIENT_SECRET, code: code , grant_type: 'authorization_code', redirect_uri: request.url.split('?')[0]}

        hash = JSON.parse(response)
        
#         render text: RestClient.get("#{HOST}/api/user", {:Authorization => "Bearer #{hash['access_token']}"})

        data = {"form"=>{"tool"=>"tron_module","responses"=>{"module_name"=>"Pharmacodynamics=> Part 1","module_url"=>"http=>//tron.rcpsych.ac.uk/default.aspx?page=22559","reflection"=>session[:notes]},"evidence_attributes"=>{"start_date"=>Date.today}}}

        response = RestClient.post "#{HOST}/api/forms", data.to_json, content_type: 'application/json', accept: 'application/json', Authorization: "Bearer #{hash['access_token']}"

        render text: response


      else
        render text: params.inspect
      end
  end
  
  def create
    #initiate authentication
    if params[:tron_module].present?
    session[:notes] = params[:tron_module][:notes]
    redirect_to "#{HOST}/oauth/authorize?client_id=#{CLIENT_ID}&redirect_uri=#{request.url}&response_type=code"
    else
      render text: params.inspect
    end

  end
    
end


# class ExamsWorker
#   include Sidekiq::Worker
# 
#   def perform(user_id)
#     NewRelic::Agent.add_custom_attributes user_id: user_id
#     if user = User.where(id: user_id).first
#       logger.info "ExamsWorker: Updating User [userid##{user_id}]"
#       
#       person_id = u user.rcpsych_number.strip rescue 0
# 
#       if person_id.to_i > 0
#         logger.info "ExamsWorker: Submitting refresh request for person_id##{person_id}"
#         #tell api to query concept
#         RestClient.put "http://api.assessmentengine.co.uk/person/#{person_id}/refresh.xml", ''
#         #...its a synchronous request so the following won't execute until its finished...
#         #now update local copy of exams data
#         %w[candidatedetails candidateexamscurrent candidateexamresults candidateexamshistory].each do |rpc|
# 
#           logger.info "ExamsWorker: RPC Call[#{rpc}] person_id##{person_id}"
# 
#           url = "http://api.assessmentengine.co.uk/person/#{person_id}/#{rpc}.xml"
#           resource = open(url)
#           xml = Nokogiri::XML(resource.read)
# 
#           exam = user.exams.find_by_rpc(rpc)
#           exam ||= user.exams.build(rpc: rpc)
#           exam.url = url
#           exam.response = xml.to_xml
#           exam.save!
#                     
#         end
#         
#         
#       else
#         logger.warn "ExamsWorker: User [userid##{user_id}] has invalid rcpsych_number [#{user.rcpsych_number}] - job aborted"
#       end
#     else
#       logger.warn "ExamsWorker: User not found [userid##{user_id}] - job aborted"
#     end
#   end
# 
# end