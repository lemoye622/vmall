import http from '@ohos.net.http';
import { HttpResponse } from '../types/HttpResponse'

// 定义基础URL
const BASE_URL = 'http://localhost:3000' // 若是模拟器访问要用ip地址
// 定义请求的超时时间
const HTTP_CONNECT_TIMEOUT = 10000;
// 定义读取响应的超时时间
const HTTP_READ_TIMEOUT = 10000;
// 定义服务器网络错误的提示消息
const SERVER_NET_ERROR = '请求数据失败';

export class HttpService {
  private static async httpRequest<T = any, R = any>(
    method: http.RequestMethod,
    apiUrl: string,
    extraData?: T // 额外的请求数据，比如请求体
  ): Promise<HttpResponse<R>> {
    // 创建http请求实例
    const httpReq = http.createHttp();
    // 配置请求参数
    const requestOptions: http.HttpRequestOptions = {
      method,
      connectTimeout: HTTP_CONNECT_TIMEOUT,
      readTimeout: HTTP_READ_TIMEOUT,
      expectDataType: http.HttpDataType.OBJECT, // 设置预期希望服务器返回的响应数据类型
    }
    // 若请求的方法不是GET且有额外的数据，要将额外的数据添加到请求选项中
    if (method !== http.RequestMethod.GET && extraData) {
      requestOptions.extraData = extraData;
    }
    try {
      const response = await httpReq.request(BASE_URL + apiUrl, requestOptions);
      return response.result as HttpResponse<R>;
    } catch (error) {
      console.error('HttpService error:', error);
      return { success: false, message: SERVER_NET_ERROR };
    }
  }

  public static get<R>(apiUrl: string): Promise<HttpResponse<R>> {
    return this.httpRequest<void, R>(http.RequestMethod.GET, apiUrl);
  }

  public static post<T, R = any>(apiUri: string, extraData?: T): Promise<HttpResponse<R>> {
    return this.httpRequest<T, R>(http.RequestMethod.POST, apiUri, extraData);
  }

  public static put<T, R = any>(apiUri: string, extraData?: T): Promise<HttpResponse<R>> {
    return this.httpRequest<T, R>(http.RequestMethod.PUT, apiUri, extraData);
  }

  public static delete<T, R = any>(apiUri: string, extraData?: T): Promise<HttpResponse<R>> {
    return this.httpRequest<T, R>(http.RequestMethod.DELETE, apiUri, extraData);
  }
}
