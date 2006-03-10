<?xml version="1.0"?>

<queryset>

    <fullquery name="select_user_info">      
        <querytext>
            select first_names,
                   last_name,
                   email,
                   to_char(creation_date, 'YYYY-MM-DD HH24:MI:SS') as registration_date,
                   to_char(last_visit, 'YYYY-MM-DD HH24:MI:SS') as last_visit
            from cc_users
            where user_id = :oneUser
        </querytext>
    </fullquery>

    <fullquery name="select_com_data">
        <querytext>
	   select f.community_key as key,
			f.community_id as id,
			f.pretty_name as pretty_name,
			to_char(o.creation_date, 'YYYY-MM-DD HH24:MI:SS') as creation_date
		from dotlrn_communities_full f, acs_objects o
		where f.community_id= :oneCom
		      and o.object_id= f.community_id
        </querytext>
    </fullquery>
    
    
	<fullquery name="select_advanced_faq_count">
        	<querytext>    
        	select count(distinct ans.entry_id)
                from faq_q_and_as ans, faqs f, dotlrn_communities com, acs_objects o
    	    	where o.object_id = f.faq_id
                    and ans.faq_id=f.faq_id    	    		
                    and o.creation_user= :oneUser
	    	    and com.community_id= :oneCom
    		    and apm_package.parent_id(o.context_id) = com.package_id
        	</querytext>
    	</fullquery>

     <fullquery name="select_advanced_total_messages_post">
        <querytext>   
    	    select count (distinct fm.message_id)	
            from forums_forums_enabled ff,
            	acs_objects o, forums_messages fm, dotlrn_communities com
            where o.object_id = fm.message_id
            	and fm.forum_id=ff.forum_id
            	and apm_package.parent_id(ff.package_id) = com.package_id
            	and com.community_id= :oneCom
            	and o.creation_user = :oneUser
         </querytext>
    </fullquery> 
 
    <fullquery name="select_advanced_total_posts_by_type">
        <querytext>
	select count(*) from acs_objects a 
		where a.creation_user = :oneUser 
		and a.object_type = :object_type 
		connect by prior a.context_id = a.object_id 
		start with a.object_id = :oneCom 
        </querytext>
    </fullquery>
    
    <fullquery name="select_advanced_forums_count">
        <querytext>
                select count(distinct forums.forum_id)
            	from forums_forums_enabled forums, dotlrn_communities com,
            	acs_objects o
            	where com.community_id= :oneCom
	    	 	and apm_package.parent_id(forums.package_id) = com.package_id
	    	 	and forums.forum_id = o.object_id and
	    	 	o.creation_user = :oneUser    
        </querytext>
    </fullquery>
    


    <fullquery name="select_advanced_surveys_count">
        <querytext>
           select count(s.survey_id)
            	from surveys s, dotlrn_communities com, acs_objects o
            	where com.community_id=:oneCom
            		and apm_package.parent_id(s.package_id) = com.package_id
            		and o.object_id=s.survey_id
            		and o.creation_user = :oneUser
        </querytext>
    </fullquery>      
        
     <fullquery name="select_advanced_news_count">
        <querytext>
            select count(n.item_id)
            	from news_items_approved n, dotlrn_communities com
            	where com.community_id= :oneCom
            	and apm_package.parent_id(n.package_id) = com.package_id
            	and n.creation_user= :oneUser
        </querytext>
    </fullquery>   
     
 
 
    <fullquery name="select_forums_count">
        <querytext>
    	    select count(distinct forums.forum_id)
            	from forums_forums_enabled forums   		
        </querytext>
    </fullquery>

    <fullquery name="select_faq_count">
        <querytext>
    	    select count(distinct f.faq_id)
                from faqs f
        </querytext>
    </fullquery>

    <fullquery name="select_news_count">
        <querytext>
            select count(distinct n.item_id)
            	from news_items_approved n
        </querytext>
    </fullquery>

    <fullquery name="select_surveys_count">
        <querytext>
           select count(distinct s.survey_id)
            	from surveys s
        </querytext>
    </fullquery>

    <fullquery name="select_package_exists">
        <querytext>
		select distinct package_key from apm_packages where package_key= :package_key
	</querytext>
    </fullquery>
 
    <fullquery name="select_total_posts_by_type">
        <querytext>
            select count(*)
            from acs_objects  
            where object_type= :object_type
        </querytext>
    </fullquery>

    <fullquery name="select_user_total_posts_by_type">
        <querytext>
            select count(*)
            from acs_objects  
            where creation_user = :oneUser 
            	and object_type= :object_type
        </querytext>
    </fullquery>

    <fullquery name="select_user_faq_count">
        <querytext>
    		select count(ans.question)
    		       from faq_q_and_as ans, faqs f, acs_objects o
    		       where o.object_id=ans.entry_id
    		             and ans.faq_id=f.faq_id
    		             and o.creation_user= :oneUser
        </querytext>
    </fullquery>
    <fullquery name="select_user_news_count">
        <querytext>
            select count(news_items_approved.publish_title)
            from news_items_approved
            where news_items_approved.creation_user= :oneUser
         </querytext>
    </fullquery>

    <fullquery name="select_community_forums_count">
        <querytext>
    	    select count(distinct forums.forum_id)
            	from forums_forums_enabled forums, dotlrn_communities com
            	where com.community_id= :oneCom
	    	 	and apm_package.parent_id(forums.package_id) = com.package_id	    		
        </querytext>
    </fullquery>
    

    <fullquery name="select_community_total_messages_post">
        <querytext>
    	    select count (distinct forums_messages.message_id)	
            from forums_forums_enabled forums,
            	acs_objects, forums_messages, dotlrn_communities com
            where acs_objects.object_id = forums_messages.message_id
            	and forums_messages.forum_id=forums.forum_id
            	and apm_package.parent_id(forums.package_id) = com.package_id
            	and com.community_id= :oneCom
         </querytext>
    </fullquery>
    
   
    <fullquery name="select_community_faq_count">
        <querytext>
    	    select count(distinct f.faq_id)
                from faqs f, dotlrn_communities com, acs_objects o
    	    	where com.community_id= :oneCom
    	    		and o.object_id=f.faq_id
	    		and apm_package.parent_id(o.context_id) = com.package_id
        </querytext>
    </fullquery>



    <fullquery name="select_community_news_count">
        <querytext>
            select count(n.item_id)
            	from news_items_approved n, dotlrn_communities com
            	where com.community_id= :oneCom
            		and apm_package.parent_id(n.package_id) = com.package_id
        </querytext>
    </fullquery>
    

    
    <fullquery name="select_community_surveys_count">
        <querytext>
           select count(s.survey_id)
            	from surveys s, dotlrn_communities com
            	where com.community_id= :oneCom
            		and apm_package.parent_id(s.package_id) = com.package_id
        </querytext>
    </fullquery>  

    
    <fullquery name="select_community_total_posts_by_type">
        <querytext>
	select count(*) from acs_objects a 
		where a.object_type = :object_type 
		connect by prior a.context_id = a.object_id 
		start with a.object_id = :oneCom 
         </querytext>
    </fullquery>   


</queryset>