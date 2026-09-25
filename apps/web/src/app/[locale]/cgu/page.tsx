import { LegalPageView, legalMetadata } from "@/components/LegalPageView";

type Props = { params: Promise<{ locale: string }> };

export const generateMetadata = ({ params }: Props) => legalMetadata("terms", params);

export default function Page({ params }: Props) {
  return <LegalPageView legalKey="terms" params={params} />;
}
