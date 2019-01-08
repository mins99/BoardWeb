package com.springbook.ioc.injection;

import org.springframework.context.support.AbstractApplicationContext;
import org.springframework.context.support.GenericXmlApplicationContext;

import polymorphism.TV;

public class CollectionBeanClient {
	public static void main(String[] args) {
		AbstractApplicationContext factory = new GenericXmlApplicationContext("applicationContext.xml");
		//CollectionBean bean = (CollectionBean) factory.getBean("collectionBean");
		TV tv = (TV)factory.getBean("tv");
		
		// 4.4.2
		/* Map<String, String> addressList = bean.getAddressList();
		for (String address : addressList) {
			System.out.println(address.toString());
		}*/
		
		// 4.4.3
		/*Map<String, String> addressList = bean.getAddressList();	
		
		for( String key : addressList.keySet() ){
            System.out.println( String.format("이름 : %s, 주소 : %s", key, addressList.get(key)) );
        }*/
		
		// 4.4.4
		/*Properties addressList = bean.getAddressList();
		
		for( String key : addressList.stringPropertyNames() ){
			System.out.println(String.format("이름 : %s, 주소 : %s", key, addressList.get(key)) );
		}
		
		factory.close();*/
		
		
	}
}
