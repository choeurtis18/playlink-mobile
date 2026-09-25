import { LegalPageView, legalMetadata } from "@/components/LegalPageView";

type Props = { params: Promise<{ locale: string }> };

export const generateMetadata = ({ params }: Props) => legalMetadata("cookies", params);

export default function Page({ params }: Props) {
  return <LegalPageView legalKey="cookies" params={params} />;
}
