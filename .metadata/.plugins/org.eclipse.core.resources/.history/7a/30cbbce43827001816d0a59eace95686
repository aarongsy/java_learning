package com.ccp.test;

import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.text.SimpleDateFormat;
import java.util.Properties;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

import org.apache.commons.io.IOUtils;
import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;

import com.ccp.dao.MnDataDao;
import com.ccp.service.MnDataService;

public class Test {
	private static SqlSessionFactory factory;
	private static Properties props;//代表持久的一套属性
	private static MnDataService service;

	static {
		InputStream is = null;
		InputStreamReader ir = null;
		props = new Properties();
		try {
			is = Resources.getResourceAsStream("mybatis-config.xml");
			//source date properties settings
			ir = new InputStreamReader(
					Resources.getResourceAsStream("args.properties"), "UTF-8");
			props.load(ir);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			IOUtils.closeQuietly(ir);
		}
		factory = new SqlSessionFactoryBuilder().build(is);
		
		MnDataDao dao = new MnDataDao();
		dao.setSqlSessionFactory(factory);
		service = new MnDataService();
		service.setDao(dao);
	}

	public static void main(String[] args) {
		
		ScheduledExecutorService schedule = Executors.newSingleThreadScheduledExecutor();
		
		final SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		schedule.scheduleAtFixedRate(new Runnable() {
			@Override
			public void run() {
				System.out.println("任务开始时间："+format.format(System.currentTimeMillis()));
				File file = new File(props.getProperty("outPath"));
				if (!file.getParentFile().exists()) {
					boolean result = file.getParentFile().mkdirs();
					if (!result) {
						System.out.println("文件目录创建失败");
					}
				}
				
				try {
					OutputStream output = new FileOutputStream(file);
					service.mnDataToFile(
							service.getMnDataLineList(props.getProperty("company")),
							output);
				} catch (Exception e) {
					e.printStackTrace();
				}
				System.out.println("任务结束时间："+format.format(System.currentTimeMillis()));
				System.out.println();
			}
		}, 0, 2, TimeUnit.MINUTES);//generate a new writing thread every 2 minutes

	}

}
