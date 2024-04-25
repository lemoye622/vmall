export interface NavigationMenu {
  id?: string;
  iconUrl: string;
  link: string;
  title: string;
  isActive: boolean;
  order: number;
  createdAt?: Date;
  updatedAt?: Date;
}
