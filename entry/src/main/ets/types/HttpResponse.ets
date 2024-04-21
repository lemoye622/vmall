export interface HttpResponse<R> {
  success: boolean;
  message: string;
  data?: R;
}