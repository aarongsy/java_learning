package weaver.interfaces.util;

import java.math.BigDecimal;

/**
 * 
 * @ClassName: BigDecimalCalculate
 * @Description: 加减乘除计算
 * @author xiyufei
 * @date 2013-10-25 下午2:14:43
 * 
 */
public class BigDecimalCalculate {
	// float点型相加
	public static String floatAdd(String a, String b) {
		a = isZero(a);
		b = isZero(b);
		BigDecimal bg1 = new BigDecimal(a);
		BigDecimal bg2 = new BigDecimal(b);

		BigDecimal bd = bg1.add(bg2);

		return bd.toString();
	}

	// float点型相减
	public static String floatSubtract(String a, String b) {
		a = isZero(a);
		b = isZero(b);
		BigDecimal bg1 = new BigDecimal(a);
		BigDecimal bg2 = new BigDecimal(b);
		BigDecimal bd = bg1.subtract(bg2);
		return bd.toString();
	}

	// 除法保留2位小数 四舍五入
	public static String floatDivide(String a, String b) {
		BigDecimal bg1 = new BigDecimal(a);
		BigDecimal bg2 = new BigDecimal(b);

		BigDecimal bd = bg1.divide(bg2, 2, BigDecimal.ROUND_HALF_UP);
		return bd.toString();
	}
	
	/**
	 * 
	 * @Title: floatDivide 舍弃多余小数
	 * @Description: 除法保留小数位
	 * @param @param a
	 * @param @param b
	 * @param @param n 几位小数
	 * @param @return 设定文件
	 * @return String 返回类型
	 * @throws
	 */
	public static String floatDivide2(String a, String b, int n) {
		a = isZero(a);
		b = isZero(b);
		BigDecimal bg1 = new BigDecimal(a);
		BigDecimal bg2 = new BigDecimal(b);

		BigDecimal bd = bg1.divide(bg2, n, BigDecimal.ROUND_DOWN);
		return bd.toString();
	}

	/**
	 * 
	 * @Title: floatDivide
	 * @Description: 除法保留小数位
	 * @param @param a
	 * @param @param b
	 * @param @param n 几位小数
	 * @param @return 设定文件
	 * @return String 返回类型
	 * @throws
	 */
	public static String floatDivide(String a, String b, int n) {
		a = isZero(a);
		b = isZero(b);
		BigDecimal bg1 = new BigDecimal(a);
		BigDecimal bg2 = new BigDecimal(b);

		BigDecimal bd = bg1.divide(bg2, n, BigDecimal.ROUND_HALF_UP);
		return bd.toString();
	}

	// 乘法
	public static String floatMultiply(String a, String b) {
		a = isZero(a);
		b = isZero(b);
		BigDecimal bg1 = new BigDecimal(a);
		BigDecimal bg2 = new BigDecimal(b);

		BigDecimal bd = bg1.multiply(bg2).setScale(2, BigDecimal.ROUND_HALF_UP);
		return bd.toString();
	}

	// 大小比较 -1 0 1
	public static int floatCompare(String a, String b) {
		a = isZero(a);
		b = isZero(b);
		BigDecimal bg1 = new BigDecimal(a);
		BigDecimal bg2 = new BigDecimal(b);

		return bg1.compareTo(bg2);
	}
	
	public static String isZero(String a) {
		if ("".equals(a)) {
			a = "0";
		}
		return a;
	}
}
