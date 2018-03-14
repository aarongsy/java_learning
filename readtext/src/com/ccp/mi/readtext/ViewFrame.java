package com.ccp.mi.readtext;

import java.awt.*;
import java.awt.event.*;
import java.util.Date;
import java.util.TimerTask;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

import javax.swing.*;

@SuppressWarnings("serial")
public class ViewFrame extends JFrame{
	//������Ҫ�����
	private JButton jtf1 = null;
	private ScheduledExecutorService schedulePool = Executors.newSingleThreadScheduledExecutor();
	//private long delay = 0L;
	//private long intevalPeriod = 5*60*1000L;
	private CRUD dao = new CRUD();
	private int count = 1;
	private int count1 = 1;
	//���ӻ�����	
	public ViewFrame() {
		setTitle("ץȡPIMS�׳���APCValues");//���ô��ڱ���
		setSize(320, 360);//���ô��ڴ�С
		setLocationRelativeTo(null);//���ô��ھ���
		setDefaultCloseOperation(EXIT_ON_CLOSE);//���ùر�ʱ�˳������
		setLayout(new FlowLayout());//���ô��ڲ���Ϊ��ʽ����
		
		jtf1 = new JButton();
		jtf1.add(new JLabel("��ʼִ�ж�ʱץȡ����"));
		add(new JLabel("�����5���Ӽ�Ъ�Զ�ץȡAPCValues�ı�"));
		add(new JLabel("*********************************"));
		add(new JLabel("�����������Ҫ�رմ˳���"));
		add(new JLabel("*********************************"));
		//add(new JLabel("����Ъ�ڼ��ı�û�и��£����ݿⲻ������ظ�����"));
		add(jtf1);
			
		jtf1.addActionListener(new ActionListener() {//����ť�����¼�
			public void actionPerformed(ActionEvent e) {
				jtf1.setEnabled(false);
				scheduleTask();
			}
		});	
	}
	//��Ъִ������
	public void scheduleTask(){
		TimerTask task = new TimerTask() {
			@Override
			public void run() {
				try{
					System.out.println(new Date().toString()+"----start----------");
					boolean flag = dao.insert(dao.getQueryList());
					if(flag){
						System.out.println(new Date().toString()+"----��"+count+"�����ݲ���ɹ�----");
						System.out.println();
						count++;
					}else{
						System.out.println(new Date().toString()+"----��"+count1+"�����ݲ���ʧ��----������������������������������---------");
						System.out.println();
						count1++;
					}
				}catch(Exception e){
					System.out.println(new Date().toString()+"----run�쳣");
					e.printStackTrace();
				}
			}
		};
		schedulePool(task);
	}
	private void schedulePool(Runnable task){
		try {
			schedulePool.scheduleAtFixedRate(task, 0, 1000*60*5, TimeUnit.MILLISECONDS);
		} catch (Exception e) {
			e.printStackTrace();
			schedulePool(task);
		}
	}
}